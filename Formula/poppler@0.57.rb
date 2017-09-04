class PopplerAT057 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.57.0.tar.xz"
  sha256 "0ea37de71b7db78212ebc79df59f99b66409a29c2eac4d882dae9f2397fe44d8"

  bottle do
    sha256 "42fd1c873083a927f05efb178ce7c0393f9cb08ef4c1733110c9826f58b02735" => :sierra
    sha256 "12b5602dec8bd91e069b5448c20bbca6026dc1ca2d4bcc9450b604a1abcc3cc5" => :el_capitan
    sha256 "7c4330ec76a5fce61d6a34b9fa6d57f3a6fc86242d8b8d614bb253893bbf1924" => :yosemite
  end

  keg_only :versioned_formula

  option "with-qt", "Build Qt5 backend"
  option "with-little-cms2", "Use color management system"

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "qt" => :optional
  depends_on "little-cms2" => :optional

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz"
    sha256 "e752b0d88a7aba54574152143e7bf76436a7ef51977c55d6bd9a48dccde3a7de"
  end

  needs :cxx11 if build.with?("qt") || MacOS.version < :mavericks

  def install
    ENV.cxx11 if build.with?("qt") || MacOS.version < :mavericks
    ENV["LIBOPENJPEG_CFLAGS"] = "-I#{Formula["openjpeg"].opt_include}/openjpeg-2.2"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-xpdf-headers
      --enable-poppler-glib
      --disable-gtk-test
      --enable-introspection=yes
      --disable-poppler-qt4
    ]

    if build.with? "qt"
      args << "--enable-poppler-qt5"
    else
      args << "--disable-poppler-qt5"
    end

    args << "--enable-cms=lcms2" if build.with? "little-cms2"

    system "./configure", *args
    system "make", "install"
    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
