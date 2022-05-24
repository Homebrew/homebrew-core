class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/easyrpg-player-0.7.0.tar.xz"
  sha256 "12149f89cc84f3a7f1b412023296cf42041f314d73f683bc6775e7274a1c9fbc"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a0c9f7c5abdaea35f7db694564b63690deee082a0210a183818a2142a559f166"
    sha256 cellar: :any,                 arm64_big_sur:  "d5ab6215a21eafaa63f33970fdb38d6680e95d6dcf9e34ff9f8cf0bcc276d4d8"
    sha256 cellar: :any,                 monterey:       "02089936499be2c1e5f9b0a537875c966488070e2a698eed1675203476fd6dfb"
    sha256 cellar: :any,                 big_sur:        "2ae20b066a7b4b499f2e8142eb4d80c4bf9bd8dbd6ef5169c9922971712de472"
    sha256 cellar: :any,                 catalina:       "bd5b78feb53c6d1b2e7224a1262a5a9fd4d350deec64bc05603a97d38c0314f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da2efd4954e7d3373dc403e69153c1f35adff2b675b65b851e77c173e045abf7"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "build/EasyRPG Player.app"
      bin.write_exec_script "#{prefix}/EasyRPG Player.app/Contents/MacOS/EasyRPG Player"
      mv "#{bin}/EasyRPG Player", "#{bin}/easyrpg-player"
    end
  end

  test do
    assert_match(/EasyRPG Player #{version}$/, shell_output("#{bin}/easyrpg-player -v"))
  end
end
