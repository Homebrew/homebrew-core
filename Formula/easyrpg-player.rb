class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/easyrpg-player-0.7.0.tar.xz"
  sha256 "12149f89cc84f3a7f1b412023296cf42041f314d73f683bc6775e7274a1c9fbc"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url "https://github.com/EasyRPG/Player.git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e8898fbb79b434b75345933dc4e5caac15a8756b500304a6c3eafbe70092bd4"
    sha256 cellar: :any,                 arm64_monterey: "a346d38b8f2323390d1fecc9c37c47298bd9052afc0cd076189f84826ef8e715"
    sha256 cellar: :any,                 arm64_big_sur:  "898f87d069f28bfab7f0db4a49755d533419408075baab30274617887b4d6fb3"
    sha256 cellar: :any,                 ventura:        "a27ba0a849fef39fef553ad595217fffb452a9ad42e52757fd1df0704d41834c"
    sha256 cellar: :any,                 monterey:       "dc89596e72cd7a078db044f33d27d0810b43a3dbedf6936323fbf76a2320d0c0"
    sha256 cellar: :any,                 big_sur:        "88d830b70f1ce15d7732c1032cd1707297b86978f508344225c86c5e736be51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7629047f8f56d4c4b846c2aa8c4115366be5946063b247486248f1bdbbced968"
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
