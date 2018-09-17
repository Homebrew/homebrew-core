class Libgxps < Formula
  desc "GObject based library for handling and rendering XPS documents"
  homepage "https://wiki.gnome.org/Projects/libgxps"
  url "https://download.gnome.org/sources/libgxps/0.2/libgxps-0.2.5.tar.xz"
  sha256 "3e7594c5c9b077171ec9ccd3ff2b4f4c4b29884d26d4f35e740c8887b40199a0"
  revision 2

  bottle do
    cellar :any
    sha256 "b1980e4de0e2d17d0232472ba8d1591d81196514461d89ea1b32a20d469ad4ad" => :mojave
    sha256 "c3e944367cacd85f4a7d2baa0c2d6174d80b586591b9664ef4b36f758ae597f9" => :high_sierra
    sha256 "4cfffe7346052e0b1e58d90c121a3f5019a5dbc84ba615f2b61d12489b6f83a6" => :sierra
    sha256 "98487c22daa05bf49ae4975759c71f568b574a55f96cdbdd9834c4d05293155c" => :el_capitan
    sha256 "234ce5d81d10db1eac54601306fb9889a549559c4e2a87e972782971103ae399" => :yosemite
  end

  head do
    url "https://github.com/GNOME/libgxps.git"

    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-man
    ]

    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    mkdir_p [
      (testpath/"Documents/1/Pages/_rels/"),
      (testpath/"_rels/"),
    ]

    (testpath/"FixedDocumentSequence.fdseq").write <<~EOS
      <FixedDocumentSequence>
      <DocumentReference Source="/Documents/1/FixedDocument.fdoc"/>
      </FixedDocumentSequence>
    EOS
    (testpath/"Documents/1/FixedDocument.fdoc").write <<~EOS
      <FixedDocument>
      <PageContent Source="/Documents/1/Pages/1.fpage"/>
      </FixedDocument>
    EOS
    (testpath/"Documents/1/Pages/1.fpage").write <<~EOS
      <FixedPage Width="1" Height="1" xml:lang="und" />
    EOS
    (testpath/"_rels/.rels").write <<~EOS
      <Relationships>
      <Relationship Target="/FixedDocumentSequence.fdseq" Type="http://schemas.microsoft.com/xps/2005/06/fixedrepresentation"/>
      </Relationships>
    EOS
    [
      "_rels/FixedDocumentSequence.fdseq.rels",
      "Documents/1/_rels/FixedDocument.fdoc.rels",
      "Documents/1/Pages/_rels/1.fpage.rels",
    ].each do |f|
      (testpath/f).write <<~EOS
        <Relationships />
      EOS
    end

    Dir.chdir(testpath) do
      system "/usr/bin/zip", "-qr", (testpath/"test.xps"), "_rels", "Documents", "FixedDocumentSequence.fdseq"
    end
    system "#{bin}/xpstopdf", (testpath/"test.xps")
  end
end
