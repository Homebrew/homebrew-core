class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9561/ghostpdl-9.56.1.tar.xz"
  sha256 "05e64c19853e475290fd608a415289dc21892c4d08ee9086138284b6addcb299"
  license "AGPL-3.0-or-later"
  revision 1

  # We check the tags from the `head` repository because the GitHub tags are
  # formatted ambiguously, like `gs9533` (corresponding to version 9.53.3).
  livecheck do
    url :stable
    regex(/href=.*?ghostpdl[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "c84daf7a848fac53bf2968239151361290ccb277accae6f11b0b39a7acb5f914"
    sha256 arm64_big_sur:  "a4f21885ac9b57f6e5511a1208b9d36ad0aa473180a2e080a9b4c23de2a5b6e9"
    sha256 monterey:       "38729b0c92a70014d82ddd57d33190019822f999efdb69d3f95e2e4cbe38fb71"
    sha256 big_sur:        "d1c4c864b2c954cf10c9023b5468652f60fb943d5ba91c190a85ef9d8224571f"
    sha256 catalina:       "335d57520e942b8547d79f62b505cc87a8afee12ecc50baccebe9dad32a0f0d0"
    sha256 x86_64_linux:   "478b2bb55a41d3afbfbdf55956180e6f653a981219dd137ba5728fbce8bed6ea"
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
  depends_on "jpeg-turbo"
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
