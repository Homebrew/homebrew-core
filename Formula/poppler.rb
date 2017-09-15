class Poppler < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.59.0.tar.xz"
  sha256 "a3d626b24cd14efa9864e12584b22c9c32f51c46417d7c10ca17651f297c9641"
  revision 1

  bottle do
    sha256 "98f5c927af0ae3037bd1281e81e239e2d8551ec7ba407bc11eafe7b2a23c2763" => :high_sierra
    sha256 "45c498c850b6e0dd469ad01a9934e8a04c382a0765c43ffd558f36ba914e53d3" => :sierra
    sha256 "6414db0c4132faa741c0103f404c7e5620caf11484bbf4455c29f87e5184a21f" => :el_capitan
    sha256 "dc7456a1f84d9125b08484bfdfa28950331656b8183368e245c66b30967f2cff" => :yosemite
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
    url "https://poppler.freedesktop.org/poppler-data-0.4.8.tar.gz"
    sha256 "1096a18161f263cccdc6d8a2eb5548c41ff8fcf9a3609243f1b6296abdf72872"
  end

  needs :cxx11 if build.with?("qt") || MacOS.version < :mavericks

  # Fix clang build failure due to missing user-provided default constructor
  # Reported 4 Sep 2017 https://bugs.freedesktop.org/show_bug.cgi?id=102538
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/656cc7f/poppler/clang.diff"
    sha256 "b95c454b78c83fc2a7cec276d4014c78aa4de48d247652eb3de3876f78875605"
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
