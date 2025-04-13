class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10050/ghostpdl-10.05.0.tar.xz"
  sha256 "f154039345b6e9957b0750f872374d887d76321d52bbcc9d3b85487855e08f02"
  license "AGPL-3.0-or-later"
  revision 1

  # The GitHub tags omit delimiters (e.g. `gs9533` for version 9.53.3). The
  # `head` repository tags are formatted fine (e.g. `ghostpdl-9.53.3`) but a
  # version may be tagged before the release is available on GitHub, so we
  # check the version from the first-party website instead.
  livecheck do
    url "https://www.ghostscript.com/json/settings.json"
    regex(/["']GS_VER["']:\s*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_sequoia: "948f72023c7ea36999720a3896e9fe6bd7bca5f729e9542a83898fc466ae5574"
    sha256 arm64_sonoma:  "92ca4fa430c750da529e54330cf8b4af147d379eed7ec737cfde9d9f1ee2c5a0"
    sha256 arm64_ventura: "64e79e4bc5ab9cf9f0b53645710a193ef4e1d75e60a8c51e66a846a47a49ad39"
    sha256 sonoma:        "707b9eea9f80bdf950e12cf7b59537302a33f5707f2e06109b24a17cc384507c"
    sha256 ventura:       "3dbff2e77ad07b6cfd12cd46caabd589e38bc2fa07c12db491e29579f6af2ab9"
    sha256 arm64_linux:   "2c35a094d9836470412654c12e5a3ea17c87cfe85063ba8bf99deefe0960d8e2"
    sha256 x86_64_linux:  "e00b681edbdf22d03d037ed0a62097b01a296e76cbced89d544306622a979d80"
  end

  head do
    url "https://git.ghostscript.com/ghostpdl.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "leptonica"
  depends_on "libarchive"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "tesseract"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "gambit-scheme", because: "both install `gsc` binary"
  conflicts_with "git-spice", because: "both install `gs` binary"

  # https://sourceforge.net/projects/gs-fonts/
  resource "fonts" do
    url "https://downloads.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz"
    sha256 "0eb6f356119f2e49b2563210852e17f57f9dcc5755f350a69a46a0d641a0c401"
  end

  def install
    # Delete local vendored sources so build uses system dependencies
    libs = %w[expat freetype jbig2dec jpeg lcms2mt leptonica libpng openjpeg tesseract tiff zlib]
    libs.each { |l| rm_r(buildpath/l) }

    configure = build.head? ? "./autogen.sh" : "./configure"

    args = %w[--disable-compile-inits
              --disable-cups
              --disable-gtk
              --with-system-libtiff
              --without-versioned-path
              --without-x]

    # Set the correct library install names so that `brew` doesn't need to fix them up later.
    ENV["DARWIN_LDFLAGS_SO_PREFIX"] = "#{opt_lib}/"
    system configure, *args, *std_configure_args

    # Install binaries and libraries
    system "make", "install"
    ENV.deparallelize { system "make", "install-so" }

    (pkgshare/"fonts").install resource("fonts")

    # Temporary backwards compatibility symlinks
    if build.stable?
      odie "Remove backwards compatibility symlink and caveat!" if version >= "10.07"
      pkgshare.install_symlink pkgshare => version.to_s
      doc.install_symlink doc => version.to_s
    end
  end

  def caveats
    <<~CAVEATS
      Ghostscript is now built `--without-versioned-path`. Temporary backwards
      compatibility symlinks exist but will be removed with 10.07.0 release.
    CAVEATS
  end

  test do
    ps = test_fixtures("test.ps")
    assert_match "Hello World!", shell_output("#{bin}/ps2ascii #{ps}")
  end
end
