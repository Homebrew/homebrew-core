class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.22.2-source.tar.gz"
  sha256 "54c66af4e6ef8cea9867cc0320ef925d561b42919ea0d4f89db5c9ef485bbeb7"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "063dfd52c7acd9860f50d15ad9527d83514e080f5bf16aa1109def88f81df981"
    sha256 cellar: :any,                 arm64_ventura:  "b1e531e94ae8e2683c28f63e68c29042937ec4ee5eacfd4c37f11116aef23b72"
    sha256 cellar: :any,                 arm64_monterey: "05e8ed2e9f956292484d58f3f57c3fb831b44ef5bb5c49b5caa7f1e146ff61b3"
    sha256 cellar: :any,                 arm64_big_sur:  "4ecd0c99b1bc6fd9082e0868c3ae2925a21dbd7e2ccc876fbb4afb0ff82b0f77"
    sha256 cellar: :any,                 sonoma:         "4629233b021c5224bb213539ad4e75acd1e2b092cb9571d6799f42952f613554"
    sha256 cellar: :any,                 ventura:        "7e08ba1465ae4de74c873aec7b9b02dd41c32898bb426e6da651c2258629ed85"
    sha256 cellar: :any,                 monterey:       "d0e4eb64e2d44d20e152465e54f0e7cadae49eb570cb491bc2d23f800576f7bc"
    sha256 cellar: :any,                 big_sur:        "2fe537a1eaec1782631c0dc705c9846ba2048b1bbc088c7489b2611183d15d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c2c8d17955d7adf74148da9b29d2913547d5dc9393252210d3e4c090816b585"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@3"

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
