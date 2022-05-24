class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9561/ghostpdl-9.56.1.tar.xz"
  sha256 "05e64c19853e475290fd608a415289dc21892c4d08ee9086138284b6addcb299"
  license "AGPL-3.0-or-later"

  # We check the tags from the `head` repository because the GitHub tags are
  # formatted ambiguously, like `gs9533` (corresponding to version 9.53.3).
  livecheck do
    url :stable
    regex(/href=.*?ghostpdl[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "29539f2c18615fb82e82e4dab331005fcde1a2310332d7edf1227d77784ef1e6"
    sha256 arm64_big_sur:  "9909bbaac3747aac9815d27837e8c9d6e1e092dfaeaeec60834ad851dc576271"
    sha256 monterey:       "3ac4eb5ecab09d810f5a866d6752d18a5cb6bb9ea4ffc2592f4cc77105633fe5"
    sha256 big_sur:        "2602d48b7b9c23249cf8791c4526988301de44910645d5f4ebab068d3bf40f6c"
    sha256 catalina:       "5b2e9e395d05d52805e3e22082207425b9ac85613cb02918e336de1809ed26e0"
    sha256 x86_64_linux:   "c0bb4afef0ba69db933901e280a820e93a02c239a2eddde6b736820de8eb17a3"
  end

  head do
    # Can't use shallow clone. Doing so = fatal errors.
    url "https://git.ghostscript.com/ghostpdl.git", branch: "master"

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
