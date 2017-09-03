class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.59.0.tar.xz"
  sha256 "a3d626b24cd14efa9864e12584b22c9c32f51c46417d7c10ca17651f297c9641"

  bottle do
    sha256 "321e13d234350ad2991d55ac8fb6a0de028e978d680f8567556a340b4480c35c" => :sierra
    sha256 "0229a1b4ac8198685b9b83b647e142a8145dd8e739d5e2701d8d94653bdb7cbc" => :el_capitan
    sha256 "e5ef8767ed20fe69710dc980d6e89eb943a9b3e507217b6bc8058a6d8d40ccb3" => :yosemite
  end

  option "with-qt", "Build Qt5 backend"
  option "with-little-cms2", "Use color management system"

  deprecated_option "with-qt4" => "with-qt"
  deprecated_option "with-qt5" => "with-qt"
  deprecated_option "with-lcms2" => "with-little-cms2"

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

  conflicts_with "pdftohtml", "pdf2image", "xpdf",
    :because => "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz"
    sha256 "e752b0d88a7aba54574152143e7bf76436a7ef51977c55d6bd9a48dccde3a7de"
  end

  needs :cxx11 if build.with?("qt") || MacOS.version < :mavericks

  # Fix clang build failure due to missing user-provided default constructor
  # Reported 4 Sep 2017 https://bugs.freedesktop.org/show_bug.cgi?id=102538
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3b766b9/poppler/clang.diff"
    sha256 "5c380a6f769758866eaa61bced5768165959aca457431eb02eeffe2c685dee87"
  end

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
