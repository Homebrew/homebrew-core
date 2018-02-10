class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "http://cdn.docbook.org/"
  url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-1.79.2.tar.gz"
  sha256 "966188d7c05fc76eaca115a55893e643dd01a3486f6368733c9ad974fcee7a26"

  bottle do
    cellar :any_skip_relocation
    sha256 "e80af394f337e21fcdbc8c8f6f0822559bfa71e5aacb192450aa71c5e0dc2257" => :high_sierra
    sha256 "4e63a12e69dc7cf292c1f4fd8f1c54f544887b809618b80b5fc3fc780f492f77" => :sierra
    sha256 "ae0cdc12fcfa0b8a1c4e72532c4bf49697de862017f5a5820093cdd26ac24e06" => :el_capitan
    sha256 "4390c7e9a0e06aeb05cc950b04991bca819279e1ced05763073b65860867a9a5" => :yosemite
    sha256 "b6166ebd526d11e436d6138d53160774b5ff95c5ff5fe5cd34841185d7529855" => :mavericks
  end

  depends_on "docbook"

  resource "ns" do
    url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-nons-1.79.2.tar.gz"
    sha256 "f89425b44e48aad24319a2f0d38e0cb6059fdc7dbaf31787c8346c748175ca8e"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    doc_files = %w[AUTHORS BUGS COPYING NEWS README RELEASE-NOTES.txt TODO VERSION VERSION.xsl]
    xsl_files = %w[assembly catalog.xml common docsrc eclipse epub epub3 extensions
                   fo highlighting html htmlhelp images javahelp lib manpages
                   params profiling roundtrip slides template tests tools webhelp
                   website xhtml xhtml-1_1 xhtml5]
    (prefix/"docbook-xsl").install xsl_files + doc_files
    resource("ns").stage do
      (prefix/"docbook-xsl-ns").install xsl_files + doc_files
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
    system "xmlcatalog", "#{etc}/xml/catalog", "http://cdn.docbook.org/release/xsl/1.79.2/"
  end
end
