class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "https://github.com/docbook/xslt10-stylesheets"
  url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-nons-1.79.2.tar.bz2"
  sha256 "ee8b9eca0b7a8f89075832a2da7534bce8c5478fc8fc2676f512d5d87d832102"

  bottle do
    cellar :any_skip_relocation
    sha256 "b05ff88c0bf8c4c39c708a92f9237ad2b870f4a065a234d0550a8343af34ef12" => :catalina
    sha256 "b05ff88c0bf8c4c39c708a92f9237ad2b870f4a065a234d0550a8343af34ef12" => :mojave
    sha256 "b05ff88c0bf8c4c39c708a92f9237ad2b870f4a065a234d0550a8343af34ef12" => :high_sierra
  end

  depends_on "docbook"

  resource "ns" do
    url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-1.79.2.tar.bz2"
    sha256 "316524ea444e53208a2fb90eeb676af755da96e1417835ba5f5eb719c81fa371"
  end

  resource "doc" do
    url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-doc-1.79.2.tar.bz2"
    sha256 "9bc38a3015717279a3a0620efb2d4bcace430077241ae2b0da609ba67d8340bc"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    doc_files = %w[AUTHORS BUGS COPYING NEWS README RELEASE-NOTES.txt TODO VERSION VERSION.xsl]
    xsl_files = %w[assembly catalog.xml common docsrc eclipse epub epub3 extensions
                   fo highlighting html htmlhelp images javahelp lib log manpages
                   params profiling roundtrip slides template tests tools webhelp
                   website xhtml xhtml-1_1 xhtml5]
    touch "log"
    (prefix/"docbook-xsl").install xsl_files + doc_files
    resource("ns").stage do
      touch "log"
      (prefix/"docbook-xsl-ns").install xsl_files + doc_files
    end
    resource("doc").stage do
      doc.install "doc" => "reference"
    end

    bin.write_exec_script "#{prefix}/docbook-xsl/epub/bin/dbtoepub"
  end

  def post_install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    [prefix/"docbook-xsl/catalog.xml", prefix/"docbook-xsl-ns/catalog.xml"].each do |catalog|
      system "xmlcatalog", "--noout", "--del", "file://#{catalog}", "#{etc}/xml/catalog"
      system "xmlcatalog", "--noout", "--add", "nextCatalog", "", "file://#{catalog}", "#{etc}/xml/catalog"
    end
  end

  test do
    system "xmlcatalog", "#{etc}/xml/catalog", "http://cdn.docbook.org/release/xsl/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://cdn.docbook.org/release/xsl/#{version}/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://cdn.docbook.org/release/xsl-nons/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://cdn.docbook.org/release/xsl-nons/#{version}/"
  end
end
