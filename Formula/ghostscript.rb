class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9550/ghostpdl-9.55.0.tar.gz"
  sha256 "b73cdfcb7b1c2a305748d23b00a765bcba48310564940b1eff1457f19f898172"
  license "AGPL-3.0-or-later"

  # We check the tags from the `head` repository because the GitHub tags are
  # formatted ambiguously, like `gs9533` (corresponding to version 9.53.3).
  livecheck do
    url :head
    regex(/^ghostpdl[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "3cc72369ec9dd8c737de7834b34bbdd92d075ddf9809a149c1cb1aaf10892778"
    sha256 arm64_big_sur:  "617fe03b1a426807c84e2b0726ab4e15c2269d8874960d134fe9000efd54c456"
    sha256 monterey:       "634c6ee7518283215456e9d1807a7f15bf9c36f49f92031c28f9d5eb13ee1fd1"
    sha256 big_sur:        "8b3824307757256005d15c6415239e435ff37c51f3585e40168494c2bcb7388c"
    sha256 catalina:       "d53bb1c34d32ee6acb0805882e11e6608f5ff198cf15def073383e6cbf609828"
    sha256 mojave:         "80587b6291bf33ea170075e279baf6c5a900f58299eac84e87a16d076840841b"
    sha256 x86_64_linux:   "89736d32c56188e51e63508ef204f1f6f6256b6778e28ed3391c90066e5b98e2"
  end

  head do
    # Can't use shallow clone. Doing so = fatal errors.
    url "https://git.ghostscript.com/ghostpdl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jbig2dec"
  depends_on "jpeg"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openjpeg"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # https://sourceforge.net/projects/gs-fonts/
  resource "fonts" do
    url "https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  patch do
    url "http://git.ghostscript.com/?p=ghostpdl.git;a=patch;h=830afae5454dea3bff903869d82022306890a96c"
    sha256 "b0b7a042e50f3eb5f7de8f8e833397953f8730030c71572ae372f44f7144c9bb"
  end

  def install
    # Fix vendored tesseract build error: 'cstring' file not found
    # Remove when possible to link to system tesseract
    ENV.append_to_cflags "-stdlib=libc++" if ENV.compiler == :clang

    # Fix VERSION file incorrectly included as C++20 <version> header
    # Remove when possible to link to system tesseract
    rm "tesseract/VERSION"

    # Delete local vendored sources so build uses system dependencies
    rm_rf "expat"
    rm_rf "freetype"
    rm_rf "jbig2dec"
    rm_rf "jpeg"
    rm_rf "lcms2mt"
    rm_rf "libpng"
    rm_rf "openjpeg"
    rm_rf "tiff"
    rm_rf "zlib"

    args = %w[
      --disable-compile-inits
      --disable-cups
      --disable-gtk
      --with-system-libtiff
      --without-x
    ]

    if build.head?
      system "./autogen.sh", *std_configure_args, *args
    else
      system "./configure", *std_configure_args, *args
    end

    # Install binaries and libraries
    system "make", "install"
    ENV.deparallelize { system "make", "install-so" }

    (pkgshare/"fonts").install resource("fonts")
    (man/"de").rmtree
  end

  test do
    ps = test_fixtures("test.ps")
    assert_match "Hello World!", shell_output("#{bin}/ps2ascii #{ps}")
  end
end
