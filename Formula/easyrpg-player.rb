class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/easyrpg-player-0.7.0.tar.xz"
  sha256 "12149f89cc84f3a7f1b412023296cf42041f314d73f683bc6775e7274a1c9fbc"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "750c687ff13d2673ccac55733ac06d6f08025494b0036df2de25eaca4212435f"
    sha256 cellar: :any,                 arm64_big_sur:  "60df6f5b55d829c737c6f534a85db694ca4469586284cd22cab9d50613bda89f"
    sha256 cellar: :any,                 monterey:       "1ae3259607bd8f4340d3c3a2914b7e646d28f5f9b65ea98e9b4a5a502c347cd5"
    sha256 cellar: :any,                 big_sur:        "481bef5afabcabe0f34eea0586fe8134161bab387c87a32fcc3ca77e69063189"
    sha256 cellar: :any,                 catalina:       "e6b485bfe87e67da97b5bc34c828889286bbac4602db5e04efae54392c60a99b"
    sha256 cellar: :any,                 mojave:         "454cf0e4e8ad0721c52346d26d29b974e568fb0c3b9c12e60d1bc8f88ddc7bc1"
    sha256 cellar: :any,                 high_sierra:    "23f7a5cbe93058e968781d35b1a94df1e23ff84942b1afb5ada3e33dfd5b9ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4560e369a92cfd63c7077351e0f802e1f8df989be7cf640091255de475613df"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
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
