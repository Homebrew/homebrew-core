class Ghostscript < Formula
  desc "Interpreter for PostScript and PDF"
  homepage "https://www.ghostscript.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10051/ghostpdl-10.05.1.tar.xz"
  sha256 "320d97f46f2f1f0e770a97d2a9ed8699c8770e46987e3a3de127855856696eb9"
  license "AGPL-3.0-or-later"

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

  bottle do
    sha256 arm64_sequoia: "29a6c1c81a8c04ccc3a1a918b7bb75843318e13c4123cd196bae785466dc572a"
    sha256 arm64_sonoma:  "f27ecbe17374b336ed1c402eb9b85afde9ab8584e472616595d66f820c38ef15"
    sha256 arm64_ventura: "186b6ef887ecf25c6391596e5512666f5b0ec9b597ab69dc23079f06a7cddac3"
    sha256 sonoma:        "d3d6fa441d393c477f19e9ba76603eb1ac087ec981c8d580608dc374fd57e2b5"
    sha256 ventura:       "af5e17cda31fd12b3060df288a2a81d6887f4f4f338c2c191528b992902eac56"
    sha256 arm64_linux:   "78257507e8c15192dd279a2332d006bdf2afbd906ea294700b3e2fdc9f7c55ae"
    sha256 x86_64_linux:  "549c239558aabcb90990f44a9c48cb13899a6d1605c62f20918ed2e5a8481bc0"
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
