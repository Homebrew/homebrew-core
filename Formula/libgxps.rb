class Libgxps < Formula
  desc "GObject based library for handling and rendering XPS documents"
  homepage "https://live.gnome.org/libgxps"
  url "https://download.gnome.org/sources/libgxps/0.2/libgxps-0.2.5.tar.xz"
  sha256 "3e7594c5c9b077171ec9ccd3ff2b4f4c4b29884d26d4f35e740c8887b40199a0"
  revision 1

  bottle do
    cellar :any
    sha256 "f16e3728361ac7d08e2c434c81f89758f32c8a05165108a125d7175c4975eed0" => :sierra
    sha256 "e1ebe0fee65e2126aa257df7c17c1f8d9804a4edf0c1c8f4405eabfa5756673b" => :el_capitan
    sha256 "438fe9b0eaa5079def5bb1a727af092ed1e6419785e03c9f42e499d6b14fa219" => :yosemite
  end

  head do
    url "https://github.com/GNOME/libgxps.git"

    depends_on "libtool" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "libarchive"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "gtk+" => :optional

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-man",
      "--prefix=#{prefix}",
    ]

    args << "--without-libjpeg" if build.without? "jpeg"
    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-liblcms2" if build.without? "lcms2"

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

    (testpath/"FixedDocumentSequence.fdseq").write <<-EOS.undent
      <FixedDocumentSequence>
      <DocumentReference Source="/Documents/1/FixedDocument.fdoc"/>
      </FixedDocumentSequence>
      EOS
    (testpath/"Documents/1/FixedDocument.fdoc").write <<-EOS.undent
      <FixedDocument>
      <PageContent Source="/Documents/1/Pages/1.fpage"/>
      </FixedDocument>
      EOS
    (testpath/"Documents/1/Pages/1.fpage").write <<-EOS.undent
      <FixedPage Width="1" Height="1" xml:lang="und" />
      EOS
    (testpath/"_rels/.rels").write <<-EOS.undent
      <Relationships>
      <Relationship Target="/FixedDocumentSequence.fdseq" Type="http://schemas.microsoft.com/xps/2005/06/fixedrepresentation"/>
      </Relationships>
      EOS
    [
      "_rels/FixedDocumentSequence.fdseq.rels",
      "Documents/1/_rels/FixedDocument.fdoc.rels",
      "Documents/1/Pages/_rels/1.fpage.rels",
    ].each do |f|
      (testpath/f).write <<-EOS.undent
        <Relationships />
        EOS
    end

    Dir.chdir(testpath) do
      system "/usr/bin/zip", "-qr", (testpath/"test.xps"), "_rels", "Documents", "FixedDocumentSequence.fdseq"
    end
    system "#{bin}/xpstopdf", (testpath/"test.xps")
  end
end
