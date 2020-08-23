class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.3.tar.xz"
  sha256 "aba34e53ef0ec6a34b58b84e28bf8cfbccee6585cebca25333604c35db3e051d"
  revision 1
  head "https://bitbucket.org/mpyne/game-music-emu.git"

  bottle do
    cellar :any
    sha256 "b1e4bc55c6071006d0f8a3ec5f48790f1e2c530ea181dfe29946b9a38c3778fa" => :catalina
    sha256 "0bf8874b6ec94564458c38292f9838df8a025adecb89a3b5b116c5f430473768" => :mojave
    sha256 "edf564750290fb0de9a5d72df0711fd658a4f73ed7ae51f567083cef812222d6" => :high_sierra
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
