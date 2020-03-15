class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "https://github.com/docbook/xslt10-stylesheets"
  url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-nons-1.79.2.tar.bz2"
  sha256 "ee8b9eca0b7a8f89075832a2da7534bce8c5478fc8fc2676f512d5d87d832102"

  bottle do
    cellar :any_skip_relocation
    sha256 "e99a33fedc074688fd4920c3c1814667625ac9944668852e66a653fec14eeaee" => :catalina
    sha256 "8aa2fdbcf7ca6ecffd1047597a1b1fa9c913e973bf2f080fea9e6dd2ac1edbc4" => :mojave
    sha256 "e80af394f337e21fcdbc8c8f6f0822559bfa71e5aacb192450aa71c5e0dc2257" => :high_sierra
    sha256 "4e63a12e69dc7cf292c1f4fd8f1c54f544887b809618b80b5fc3fc780f492f77" => :sierra
    sha256 "ae0cdc12fcfa0b8a1c4e72532c4bf49697de862017f5a5820093cdd26ac24e06" => :el_capitan
    sha256 "4390c7e9a0e06aeb05cc950b04991bca819279e1ced05763073b65860867a9a5" => :yosemite
    sha256 "b6166ebd526d11e436d6138d53160774b5ff95c5ff5fe5cd34841185d7529855" => :mavericks
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
