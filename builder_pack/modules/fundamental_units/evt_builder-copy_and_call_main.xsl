<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Copyright (C) 2013-2017 the EVT Development Team.
    
    EVT 1 is free software: you can redistribute it 
    and/or modify it under the terms of the 
    GNU General Public License version 2
    available in the LICENSE file (or see <http://www.gnu.org/licenses/>).
    
    EVT 1 is distributed in the hope that it will be useful, 
    but WITHOUT ANY WARRANTY; without even the implied 
    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the GNU General Public License for more details. 
-->
<xsl:stylesheet xpath-default-namespace="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:eg="http://www.tei-c.org/ns/Examples"
	xmlns:xd="http://www.pnp-software.com/XSLTdoc" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="#all">

	<xd:doc type="stylesheet">
		<xd:short> EN: This stylesheet creates a copy of the document where the l element is closed
			(and later re-opened) whenever it is interrupted by a pb or lb element. For each page
			present in this copy the page template is applied (which is in evt_builder-main) IT:
			Crea una copia del documento nella quale il tag l viene chiuso (e poi ri-aperto) tutte
			le volte che è interrotto da un pb o un lb. Per ogni pagina presente in questa copia
			viene chiamato il template page (questo template si trova in evt_builder-main)
		</xd:short>
	</xd:doc>


	<!-- MULTI PHASE TRANSFORMATION -->
	<!-- EN: Close and open back elements when you find a pb or an lb -->
	<!-- IT: Chiudi e riapri i tag quando trovi un pb o un lb -->
	<xsl:template
		match="node()[name() = $start_split or name() = 'front']//node()[lb[@* and not(@rend = 'empty')] | pb | cb][not(descendant::node()[lb[@* and not(@rend = 'empty')] | pb | cb])]"
		mode="splitLbPb">
		<xsl:for-each-group select="node()" group-starting-with="lb[@* and not(@rend = 'empty')] | pb | cb">
			<!-- EN: copy lb/pb if present in this group -->
			<!-- IT: copia lb/pb se presente nel gruppo -->
			<xsl:if
				test="current-group()/(descendant-or-self::lb[@* and not(@rend = 'empty')] | descendant-or-self::pb | descendant-or-self::cb)">
				<!-- Management of words broken into two lines, to be normalized in the interpretative edition -->
				<!-- Gestione parole spezzate su due righe, da normalizzare nell'edizione interpretativa -->
			  <xsl:if test="ancestor::tei:w and ancestor::tei:w/node()/name()='w'">
			    <xsl:element name="{ancestor::tei:w/name()}" xmlns="http://www.tei-c.org/ns/1.0">
						<xsl:attribute name="info" select="'complete_word'"/>
						<!-- <xsl:value-of select="ancestor::tei:w/node()[normalize-space()]"></xsl:value-of> -->
						<xsl:sequence select="ancestor::tei:w/node()[not(self::lb[@* and not(@rend = 'empty')])]"/>
					</xsl:element>
				</xsl:if>
				<!-- // end // -->
				<xsl:sequence
					select="current-group()/(descendant-or-self::lb[@* and not(@rend = 'empty')] | descendant-or-self::pb | descendant-or-self::cb)"
				/>
			</xsl:if>
			<!-- EN: Copies the elements in the group except lb/pb -->
			<xsl:element name="{parent::node()/name()}" xmlns="http://www.tei-c.org/ns/1.0">
				<xsl:copy-of select="parent::node()/@* except (parent::node()/@part)"/>
				<xsl:attribute name="part" select="position()"/>
				<xsl:choose>
					<xsl:when test="parent::node()/tei:lb">
						<xsl:attribute name="group" select="'lb'"/>
					</xsl:when>
					<xsl:when test="parent::node()/tei:cb">
						<xsl:attribute name="group" select="'cb'"/>
					</xsl:when>
					<xsl:when test="parent::node()/tei:pb">
						<xsl:attribute name="group" select="'pb'"/>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="id" select="generate-id(parent::node())"/>
				<!-- Management of words broken into two lines, to be normalized in the interpretative edition -->
				<!-- Gestione parole spezzate su due righe, da normalizzare nell'edizione interpretativa -->
				<xsl:if test="parent::node()/name()='w' and parent::node()/tei:lb">
					<xsl:attribute name="info" select="'broken_word'"/>
				</xsl:if>
				<!-- // end // -->
				<xsl:sequence select="current-group()[not(self::lb[@* and not(@rend = 'empty')] | self::pb | self::cb)]"/>
			</xsl:element>
		</xsl:for-each-group>
	</xsl:template>



	<!-- EN: Copy all -->
	<!-- IT: Copia tutto -->
	<xsl:template match="@* | node()" mode="splitLbPb">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- EN: Recursive calls on variables to close and open all elements broken by lb/pb -->
	<!-- IT: Chiamate ricorsive sulla variabili per chiudere e aprire tutti i tag spezzati da lb/pb -->
	<xsl:variable name="step0">
		<xsl:apply-templates select="$step-1" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-1">
		<xsl:apply-templates select="$step-2" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-2">
		<xsl:apply-templates select="$step-3" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-3">
		<xsl:apply-templates select="$step-4" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-4">
		<xsl:apply-templates select="$step-5" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-5">
		<xsl:apply-templates select="$step-6" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-6">
		<xsl:apply-templates select="$step-7" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-7">
		<xsl:apply-templates select="$step-8" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-8">
		<xsl:apply-templates select="$step-9" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-9">
		<xsl:apply-templates select="$step-10" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-10">
		<xsl:apply-templates select="$step-11" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-11">
		<!--  <xsl:apply-templates select="//node()[name()=$ed_content]" mode="splitLbPb"/>-->
		<xsl:apply-templates select="$step-12" mode="splitLbPb"/>
	</xsl:variable>

	<xsl:variable name="step-12">
		<!--  <xsl:apply-templates select="//node()[name()=$ed_content]" mode="splitLbPb"/>-->
		<xsl:apply-templates select="//tei:TEI" mode="splitLbPb"/>
	</xsl:variable>

	<!-- ADD NEW STEP -->
	<!--
		EN: to add a new level modify the previous variable as follows (increase the select value by one and add the corresponding variable):
		IT: per aggiungere un nuovo livello modificare la precedente variabile nel seguente modo (incrementare di 1 il valore del select e aggiungere la corrispondente variabile):
		<xsl:variable name="step-5">
			<xsl:apply-templates select="step-6" mode="splitLbPb"/>
		</xsl:variable>
		
		<xsl:variable name="step-6">
			<xsl:apply-templates select="//tei:TEI" mode="splitLbPb"/>
		</xsl:variable>
	-->


	<!-- END OF MULTI PHASE TRANSFORMATION -->

	<xsl:template match="*" mode="file4search">
		<!-- IT: Per ogni pagina, genera le corrispettive edizioni. Il template data_structure si trova in html_build/evt_builder-callhtml.xsl -->
		<xsl:call-template name="search_file"/>
	</xsl:template>

	<!--EN: Calls the page template for every page -->
	<!--IT: Per ogni pagina chiama il template page -->
	<xsl:template match="*" mode="splitPages">
		<!--<xsl:copy-of select="*"></xsl:copy-of>-->
		<xsl:for-each-group
			select="//node()[name() = $ed_content]/descendant-or-self::node()[name() = 'front']/node()" 
                    	group-starting-with="//tei:pb">
			<xsl:if test="self::tei:pb[not(@type='end')]">
				<!--IT: test per non creare una pagina per un gruppo che non inizia con pb (puo succedere al primo gruppo)  -->
				<xsl:call-template name="page"/>
				<!-- See: evt_builder-main -->
			</xsl:if>
		</xsl:for-each-group>
		<xsl:for-each-group
			select="//node()[name() = $ed_content]/descendant-or-self::node()[name() = $start_split]/node()"
			group-starting-with="//tei:pb">
			<xsl:if test="self::tei:pb[not(@type='end')]">
				<!--IT: test per non creare una pagina per un gruppo che non inizia con pb (puo succedere al primo gruppo)  -->
				<xsl:call-template name="page"/>
				<!-- See: evt_builder-main -->
			</xsl:if>
		</xsl:for-each-group>
		<!--EN: Calls the template that generates the index -->
		<!--IT: Chiama il template per la generazione della index -->
		<!--<xsl:call-template name="index"></xsl:call-template>-->
	</xsl:template>

	<xsl:template name="generatePbLabel">
		<xsl:param name="pb"/>
		<xsl:param name="position"/>
		<xsl:choose>
			<xsl:when test="$pb/@n">
				<xsl:value-of select="$pb/@n"/>
			</xsl:when>
			<xsl:when test="$pb/@xml:id">
				<xsl:value-of select="$pb/@xml:id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$position"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- CDP: Listes -->
	<xsl:template match="*" mode="listPersonOccurences">
		<xsl:element name="div">
			<xsl:attribute name="id">occorrenze_listPerson</xsl:attribute>
			<xsl:for-each-group
				select="//node()[name() = $ed_content]/descendant-or-self::node()[name() = $start_split]/node()"
				group-starting-with="//tei:pb">
				<xsl:if test="self::tei:pb">
					<xsl:variable name="pb_id" select="@xml:id"/>
					<xsl:variable name="pb_n">
						<xsl:call-template name="generatePbLabel">
							<xsl:with-param name="pb" select="current()"/>
							<xsl:with-param name="position" select="position()"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:for-each
						select="current-group()/descendant::tei:persName[starts-with(@ref, '#')]">
						<xsl:variable name="doc_id">
							<xsl:choose>
								<xsl:when test="current()/ancestor::tei:text[1]/@xml:id">
									<xsl:value-of select="current()/ancestor::tei:text[1]/@xml:id"/>
								</xsl:when>
								<xsl:when
									test="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id">
									<xsl:value-of
										select="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="count(current()/ancestor::tei:text[1]/preceding-sibling::tei:text) + 1"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="span">
							<xsl:attribute name="data-list">listPerson</xsl:attribute>
							<xsl:attribute name="data-ref">
								<xsl:value-of select="translate(@ref, '#', '')"/>
							</xsl:attribute>
							<xsl:attribute name="data-doc">
								<xsl:value-of select="$doc_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb">
								<xsl:value-of select="$pb_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb-n">
								<xsl:value-of select="$pb_n"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*" mode="listPlaceOccurences">
		<xsl:element name="div">
			<xsl:attribute name="id">occorrenze_listPlace</xsl:attribute>
			<xsl:for-each-group
				select="//node()[name() = $ed_content]/descendant-or-self::node()[name() = $start_split]/node()"
				group-starting-with="//tei:pb">
				<xsl:if test="self::tei:pb">
					<xsl:variable name="pb_id" select="@xml:id"/>
					<xsl:variable name="pb_n">
						<xsl:call-template name="generatePbLabel">
							<xsl:with-param name="pb" select="current()"/>
							<xsl:with-param name="position" select="position()"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:for-each
						select="current-group()/descendant::tei:placeName[starts-with(@ref, '#')]">
						<xsl:variable name="doc_id">
							<xsl:choose>
								<xsl:when test="current()/ancestor::tei:text[1]/@xml:id">
									<xsl:value-of select="current()/ancestor::tei:text[1]/@xml:id"/>
								</xsl:when>
								<xsl:when
									test="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id">
									<xsl:value-of
										select="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="count(current()/ancestor::tei:text[1]/preceding-sibling::tei:text) + 1"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="span">
							<xsl:attribute name="data-list">listPlace</xsl:attribute>
							<xsl:attribute name="data-ref">
								<xsl:value-of select="translate(@ref, '#', '')"/>
							</xsl:attribute>
							<xsl:attribute name="data-doc">
								<xsl:value-of select="$doc_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb">
								<xsl:value-of select="$pb_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb-n">
								<xsl:value-of select="$pb_n"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:template>

	<xsl:template match="*" mode="listOrgOccurences">
		<xsl:element name="div">
			<xsl:attribute name="id">occorrenze_listOrg</xsl:attribute>
			<xsl:for-each-group
				select="//node()[name() = $ed_content]/descendant-or-self::node()[name() = $start_split]/node()"
				group-starting-with="//tei:pb">
				<xsl:if test="self::tei:pb">
					<xsl:variable name="pb_id" select="@xml:id"/>
					<xsl:variable name="pb_n">
						<xsl:call-template name="generatePbLabel">
							<xsl:with-param name="pb" select="current()"/>
							<xsl:with-param name="position" select="position()"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:for-each select="$root//tei:listOrg">
						<xsl:if test="@type">
							<xsl:variable name="listType" select="@type"/>
							<xsl:for-each select="current-group()/descendant::tei:name">
								<xsl:variable name="refEl" select="$root//tei:listOrg[@type = $listType]//node()[@xml:id = substring-after(current()/@ref, '#')]"/>
								<xsl:if test="current()/@ref and $refEl">
									<xsl:variable name="doc_id">
										<xsl:choose>
											<xsl:when test="current()/ancestor::tei:text[1]/@xml:id">
												<xsl:value-of select="current()/ancestor::tei:text[1]/@xml:id"/>
											</xsl:when>
											<xsl:when
												test="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id">
												<xsl:value-of
													select="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id"
												/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="count(current()/ancestor::tei:text[1]/preceding-sibling::tei:text) + 1"
												/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:element name="span">
										<xsl:attribute name="data-list">listOrg</xsl:attribute>
										<xsl:attribute name="data-list-type"><xsl:value-of select="$listType"/></xsl:attribute>
										<xsl:attribute name="data-ref">
											<xsl:value-of select="translate(@ref, '#', '')"/>
										</xsl:attribute>
										<xsl:attribute name="data-doc">
											<xsl:value-of select="$doc_id"/>
										</xsl:attribute>
										<xsl:attribute name="data-pb">
											<xsl:value-of select="$pb_id"/>
										</xsl:attribute>
										<xsl:attribute name="data-pb-n">
											<xsl:value-of select="$pb_n"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each
						select="current-group()/descendant::tei:orgName[starts-with(@ref, '#')]">
						<xsl:variable name="doc_id">
							<xsl:choose>
								<xsl:when test="current()/ancestor::tei:text[1]/@xml:id">
									<xsl:value-of select="current()/ancestor::tei:text[1]/@xml:id"/>
								</xsl:when>
								<xsl:when
									test="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id">
									<xsl:value-of
										select="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="count(current()/ancestor::tei:text[1]/preceding-sibling::tei:text) + 1"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="span">
							<xsl:attribute name="data-list">listOrg</xsl:attribute>
							<xsl:attribute name="data-ref">
								<xsl:value-of select="translate(@ref, '#', '')"/>
							</xsl:attribute>
							<xsl:attribute name="data-doc">
								<xsl:value-of select="$doc_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb">
								<xsl:value-of select="$pb_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb-n">
								<xsl:value-of select="$pb_n"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:template>

	<!-- TERM OCCURRENCES -->
	<xsl:template match="*" mode="listTermOccurences">
		<xsl:element name="div">
			<xsl:attribute name="id">occorrenze_listTerm</xsl:attribute>
			<xsl:for-each-group
				select="//node()[name() = $ed_content]/descendant-or-self::node()[name() = $start_split]/node()"
				group-starting-with="//tei:pb">
				<xsl:if test="self::tei:pb">
					<xsl:variable name="pb_id" select="@xml:id"/>
					<xsl:variable name="pb_n">
						<xsl:call-template name="generatePbLabel">
							<xsl:with-param name="pb" select="current()"/>
							<xsl:with-param name="position" select="position()"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:for-each select="current-group()/descendant::tei:term">
						<xsl:variable name="doc_id">
							<xsl:choose>
								<xsl:when test="current()/ancestor::tei:text[1]/@xml:id">
									<xsl:value-of select="current()/ancestor::tei:text[1]/@xml:id"/>
								</xsl:when>
								<xsl:when
									test="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id">
									<xsl:value-of
										select="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="count(current()/ancestor::tei:text[1]/preceding-sibling::tei:text) + 1"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="span">
							<xsl:attribute name="data-list">listTerm</xsl:attribute>
							<xsl:variable name="termText">
								<xsl:apply-templates select="current()"/>
							</xsl:variable>
							<xsl:attribute name="data-ref"
								select="translate(normalize-space($termText), ' ', '')"/>
							<xsl:attribute name="data-doc">
								<xsl:value-of select="$doc_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb">
								<xsl:value-of select="$pb_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb-n">
								<xsl:value-of select="$pb_n"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:template>

	<!-- GLOSS OCCURRENCES -->
	<xsl:template match="*" mode="listGlossOccurences">
		<xsl:element name="div">
			<xsl:attribute name="id">occorrenze_listGloss</xsl:attribute>
			<xsl:for-each-group
				select="//node()[name() = $ed_content]/descendant-or-self::node()[name() = $start_split]/node()"
				group-starting-with="//tei:pb">
				<xsl:if test="self::tei:pb">
					<xsl:variable name="pb_id" select="@xml:id"/>
					<xsl:variable name="pb_n">
						<xsl:call-template name="generatePbLabel">
							<xsl:with-param name="pb" select="current()"/>
							<xsl:with-param name="position" select="position()"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:for-each select="current-group()/descendant::tei:gloss">
						<xsl:variable name="doc_id">
							<xsl:choose>
								<xsl:when test="current()/ancestor::tei:text[1]/@xml:id">
									<xsl:value-of select="current()/ancestor::tei:text[1]/@xml:id"/>
								</xsl:when>
								<xsl:when
									test="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id">
									<xsl:value-of
										select="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="count(current()/ancestor::tei:text[1]/preceding-sibling::tei:text) + 1"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="span">
							<xsl:variable name="glossText">
								<xsl:apply-templates select="current()"/>
							</xsl:variable>
							<xsl:attribute name="data-list">listGloss</xsl:attribute>
							<xsl:attribute name="data-ref"
								select="translate(normalize-space($glossText), ' ', '')"/>
							<xsl:attribute name="data-doc">
								<xsl:value-of select="$doc_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb">
								<xsl:value-of select="$pb_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb-n">
								<xsl:value-of select="$pb_n"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:template>

	<!-- GLOSSARY OCCURRENCES -->
	<xsl:template match="*" mode="listGlossaryOccurences">
		<xsl:element name="div">
			<xsl:attribute name="id">occorrenze_listGlossary</xsl:attribute>
			<xsl:for-each-group
				select="//node()[name() = $ed_content]/descendant-or-self::node()[name() = $start_split]/node()"
				group-starting-with="//tei:pb">
				<xsl:if test="self::tei:pb">
					<xsl:variable name="pb_id" select="@xml:id"/>
					<xsl:variable name="pb_n">
						<xsl:call-template name="generatePbLabel">
							<xsl:with-param name="pb" select="current()"/>
							<xsl:with-param name="position" select="position()"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:for-each select="current-group()/descendant::tei:term">
						<xsl:variable name="doc_id">
							<xsl:choose>
								<xsl:when test="current()/ancestor::tei:text[1]/@xml:id">
									<xsl:value-of select="current()/ancestor::tei:text[1]/@xml:id"/>
								</xsl:when>
								<xsl:when
									test="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id">
									<xsl:value-of
										select="current()/ancestor::tei:body[1]/tei:div[@subtype = 'edition_text']/@xml:id"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="count(current()/ancestor::tei:text[1]/preceding-sibling::tei:text) + 1"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:element name="span">
							<xsl:attribute name="data-list">listGlossary</xsl:attribute>
							<xsl:variable name="termText">
								<xsl:apply-templates select="current()"/>
							</xsl:variable>
							<xsl:attribute name="data-ref"
								select="translate(normalize-space($termText), ' ', '')"/>
							<xsl:attribute name="data-doc">
								<xsl:value-of select="$doc_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb">
								<xsl:value-of select="$pb_id"/>
							</xsl:attribute>
							<xsl:attribute name="data-pb-n">
								<xsl:value-of select="$pb_n"/>
							</xsl:attribute>
						</xsl:element>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:element>
	</xsl:template>

	<!-- GM -->
	<!--<xsl:template match="/" mode="viscollCP"> 
		<xsl:copy-of select="./*" />
	</xsl:template>-->

	<!--CDP:embedded -->
	<!--EN: Calls the page template for every page. The page is identified with the <surface> element inside a <sourceDoc> -->
	<!--IT: Per ogni pagina chiama il template page. La pagina viene identificata con l'elemento <surface> in <sourceDoc> -->
	<xsl:template match="*" mode="splitPages4embedded">
		<!--<xsl:copy-of select="*"></xsl:copy-of>-->
		<!-- EN: The split in pages is iterated for every single <sourceDoc> element -->
		<!-- IT: La divisione in pagine viene ripetuta per ogni diverso <sourceDoc> -->
		<xsl:for-each-group select="$root//tei:sourceDoc" group-by="@xml:id">
			<xsl:call-template name="pagesInSourceDoc"/>
		</xsl:for-each-group>
		<!--EN: Calls the template that generates the index -->
		<!--IT: Chiama il template per la generazione della index -->
		<!--<xsl:call-template name="index"></xsl:call-template>-->
	</xsl:template>

	<!-- IT: ricorsione per generare le pagine a tutti i livelli di annidamento rispetto a tei:sorceDoc nella ET-->
	<xsl:template name="pagesInSourceDoc">
		<xsl:for-each-group select="current-group()/tei:surface" group-by="@xml:id">
			<xsl:call-template name="page"/>
			<!-- See: evt_builder-main -->
		</xsl:for-each-group>
		<xsl:for-each-group select="current-group()/tei:surfaceGrp[tei:surface]" group-by="@xml:id">
			<xsl:call-template name="pagesInSourceDoc"/>
		</xsl:for-each-group>
	</xsl:template>

	<xsl:template match="*" mode="file4search4embedded">
		<xsl:call-template name="search_file4embedded"/>
	</xsl:template>
</xsl:stylesheet>
