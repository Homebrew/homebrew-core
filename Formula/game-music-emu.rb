class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.3.tar.xz"
  sha256 "aba34e53ef0ec6a34b58b84e28bf8cfbccee6585cebca25333604c35db3e051d"
  revision 2
  head "https://bitbucket.org/mpyne/game-music-emu.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "a0abdc4c5ae05ea22ad3627a1a717ed8a1a137065188b995858c0f301dfda640" => :big_sur
    sha256 "e83fbee26086cc93f7d2eed7d3b93f00a0a0c9eb9d59abf3aba91216fe89d3d8" => :arm64_big_sur
    sha256 "ee658e16c3d9d0061b0b930ca387a1cb2fa6b6b50d23c9f6f4ae7799ddb6f46d" => :catalina
    sha256 "754ab0c8bc0a6de76adcb56a59913c930196e8e44154958081c093fb7763edad" => :mojave
    sha256 "596497823bb1ebb30f20fa01c8656bb15544c12fad5d67c4de165f9ef3122e68" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gme/gme.h>
      int main(void)
      {
        Music_Emu* emu;
        gme_err_t error;

        error = gme_open_data((void*)0, 0, &emu, 44100);

        if (error == gme_wrong_file_type) {
          return 0;
        } else {
          return -1;
        }
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lgme", "-o", "test", *ENV.cflags.to_s.split
    system "./test"
  end
end
