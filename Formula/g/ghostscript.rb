class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10060/ghostpdl-10.06.0.tar.xz"
  sha256 "3602056368cf649026231e2d65250b5860c023f3d4a0d9c35e6605e28e543ec1"
  license "AGPL-3.0-or-later"
  revision 1

  # The GitHub tags omit delimiters (e.g. `gs9533` for version 9.53.3). The
  # `head` repository tags are formatted fine (e.g. `ghostpdl-9.53.3`) but a
  # version may be tagged before the release is available on GitHub, so we
  # check the version from the first-party website instead.
  livecheck do
    url "https://www.ghostscript.com/json/settings.json"
    strategy :json do |json|
      json["GS_VER"]
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "36245de09fc9100dff794142e7ca847b465d24109c3b4e66fcda28e8818850c1"
    sha256 arm64_sequoia: "1aeb2dae71bdcd521ef298e114b49ba4fce87b47865aa86cac97a449d2870d63"
    sha256 arm64_sonoma:  "2c4c3bd4bdded514714ffc1ed0f554f7399eda311d3df64af1a45e5219b41d20"
    sha256 sonoma:        "1849aec43a04e46e21b370fdeff7efd1cfcac63d017c9fc44dc235e6f2fa47af"
    sha256 arm64_linux:   "c81897d05d33d36448bb7e9d4da9ea0d30dd16ababdd5265662e8ebec296d3ef"
    sha256 x86_64_linux:  "0c0ab563da757f637d27ac01d11013738701e3fdeef696e89ed878de66c5cdca"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "gambit-scheme", because: "both install `gsc` binary"
  conflicts_with "gerbil-scheme", because: "both install `gsc` binary"
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
    ENV.append_to_cflags "-fPIC" if OS.linux?
    ENV["XCFLAGS"] = ENV.cflags
    ENV["XCXXFLAGS"] = ENV.cxxflags

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
