class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.3.tar.xz"
  sha256 "aba34e53ef0ec6a34b58b84e28bf8cfbccee6585cebca25333604c35db3e051d"
  head "https://bitbucket.org/mpyne/game-music-emu.git"

  bottle do
    cellar :any
    sha256 "dc7859c227ff5014c83f33afcd2e8e433fee630aaa21d95f279f925dd9844aa0" => :catalina
    sha256 "0d58fd959b1df0444911fc35ddba954ad3aa93975940a6657105475558a33da6" => :mojave
    sha256 "a2f6918a7291a0478faab60f7aacc30f7086de599bf40db4a284c45627d65540" => :high_sierra
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
