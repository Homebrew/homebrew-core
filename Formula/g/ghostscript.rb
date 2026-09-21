class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10080/ghostpdl-10.08.0.tar.xz"
  sha256 "94943e3c4adb7115d132b3c28b913672f2e62e6a9d802f7e754e716b1634174a"
  license "AGPL-3.0-or-later"
  compatibility_version 1

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
    sha256 arm64_golden_gate: "20d8eff70c436899114af3b971cc0108a63a1c086da53e933802ddd33f6cf283"
    sha256 arm64_tahoe:       "9fdf9326aaf65459113953809f9abbffbd48e99158ba7a3505895bd61df89e46"
    sha256 arm64_sequoia:     "e2ef1284b4e8818c789f968ffa2193b9d4f51c0879ca1d2a93be5239efc2bc95"
    sha256 arm64_sonoma:      "be72b022398cf813a67a667dd0b5537d78b178808002af8f653365d8594d29f1"
    sha256 arm64_linux:       "3e85f7ce71f33514c033e2018f7414a0cec27095c6fc65de7786814e758050a4"
    sha256 x86_64_linux:      "94327e6306a4691f6967628aaa58c160a4a78f46ae793f05316e0a7a13a49f2b"
  end

  head do
    url "https://github.com/ArtifexSoftware/ghostpdl.git", branch: "master"

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
