class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "https://github.com/docbook/xslt10-stylesheets"
  url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-nons-1.79.2.tar.bz2"
  sha256 "ee8b9eca0b7a8f89075832a2da7534bce8c5478fc8fc2676f512d5d87d832102"
  # Except as otherwise noted, for example, under some of the /contrib/
  # directories, the DocBook XSLT 1.0 Stylesheets use The MIT License.
  license "MIT"
  revision 1

  livecheck do
    url :homepage
    regex(%r{^(?:release/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97d7b10fee85c4ad08218efa4b9527b40a412d1e6b439612a76c5eb9c3fe22cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d7b10fee85c4ad08218efa4b9527b40a412d1e6b439612a76c5eb9c3fe22cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97d7b10fee85c4ad08218efa4b9527b40a412d1e6b439612a76c5eb9c3fe22cd"
    sha256 cellar: :any_skip_relocation, tahoe:         "51db3d441aca723d738e3524a4de0e892c0cc659b4ea3f14f3c921c0176e3769"
    sha256 cellar: :any_skip_relocation, sequoia:       "51db3d441aca723d738e3524a4de0e892c0cc659b4ea3f14f3c921c0176e3769"
    sha256 cellar: :any_skip_relocation, sonoma:        "51db3d441aca723d738e3524a4de0e892c0cc659b4ea3f14f3c921c0176e3769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97d7b10fee85c4ad08218efa4b9527b40a412d1e6b439612a76c5eb9c3fe22cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d7b10fee85c4ad08218efa4b9527b40a412d1e6b439612a76c5eb9c3fe22cd"
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

  # see https://www.linuxfromscratch.org/blfs/view/9.1/pst/docbook-xsl.html for this patch
  patch do
    file "Patches/docbook-xsl/docbook-xsl-nons-1.79.2-stack_fix-1.patch"
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

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      set -e
      catalog="#{etc}/xml/catalog"
      export XML_CATALOG_FILES="$catalog"
      for names in "xsl xsl-nons" "xsl-ns xsl"; do
        set -- $names
        old_name="$1"
        new_name="$2"
        location="file://#{opt_prefix}/docbook-$old_name"
        entry="$location/catalog.xml"
        xmlcatalog --noout --del "$entry" "$catalog"
        xmlcatalog --noout --add nextCatalog "" "$entry" "$catalog"
        for url in "https://cdn.docbook.org/release/$new_name" \
                   "http://docbook.sourceforge.net/release/$old_name"; do
          for version in "#{version}" current; do
            xmlcatalog --noout --del "$url/$version" "$catalog"
            xmlcatalog --noout --add rewriteSystem "$url/$version" "$location" "$catalog"
            xmlcatalog --noout --add rewriteURI "$url/$version" "$location" "$catalog"
          done
        done
      done
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    run "post-install", base: :libexec
  end

  test do
    system "xmlcatalog", "#{etc}/xml/catalog", "https://cdn.docbook.org/release/xsl-nons/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "https://cdn.docbook.org/release/xsl-nons/#{version}/"
    system "xmlcatalog", "#{etc}/xml/catalog", "https://cdn.docbook.org/release/xsl/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "https://cdn.docbook.org/release/xsl/#{version}/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl/#{version}/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl-ns/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl-ns/#{version}/"
  end
end
