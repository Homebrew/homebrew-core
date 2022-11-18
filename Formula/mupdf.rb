class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.20.3-source.tar.lz"
  sha256 "6f73f63ef8aa81991dfd023d4426a548827d1d74e0bfcf2a013acad63b651868"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ffb56d1bfb6207f217c62024380506fc6a7806270b1b84c6bd751c1c4c17b5c"
    sha256 cellar: :any,                 arm64_monterey: "fd53c923bf3ef8d6dfbc4e17d964dea8f654f33895ab17bc68a13e7257f31d99"
    sha256 cellar: :any,                 arm64_big_sur:  "d4de8eca45bddbaaffa4f967810e4cccf6bea5fddada820dd485e32459091e8f"
    sha256 cellar: :any,                 ventura:        "d5887088e8636605da86c9499734aa214b6d2c6c04e51108d381d7268e6a913f"
    sha256 cellar: :any,                 monterey:       "ba5d902321147f9c470410c4cc2cd65e4f327a48ed604ba10afe807aff2494cd"
    sha256 cellar: :any,                 big_sur:        "e1ca6bb0d8578b49f7bd53377fc52e8c55b98e8861b849199855b5c70430188a"
    sha256 cellar: :any,                 catalina:       "453fe6af4893acd064313e020018e96a9928abbd24e9fb9132247c217635cde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d2ad0097c293160cbb9d3932ae311a11cb4c13f47d11577c654d0827c95b831"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
  end

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    # Remove bundled libraries excluding `extract` and "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract lcms2]
    (buildpath/"thirdparty").each_child { |path| path.rmtree if keep.exclude? path.basename.to_s }

    args = %W[
      build=release
      shared=yes
      verbose=yes
      prefix=#{prefix}
      CC=#{ENV.cc}
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=yes
    ]
    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
        ["GUMBO", "gumbo"],
        ["HARFBUZZ", "harfbuzz"],
        ["LIBJPEG", "libjpeg"],
        ["OPENJPEG", "libopenjp2"],
      ].each do |argname, libname|
        args << "SYS_#{argname}_CFLAGS=#{Utils.safe_popen_read("pkg-config", "--cflags", libname).strip}"
        args << "SYS_#{argname}_LIBS=#{Utils.safe_popen_read("pkg-config", "--libs", libname).strip}"
      end
    end
    system "make", "install", *args

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
