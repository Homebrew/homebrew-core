class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.2.tar.xz"
  sha256 "5046cb471d422dbe948b5f5dd4e5552aaef52a0899c4b2688e5a68a556af7342"
  head "https://bitbucket.org/mpyne/game-music-emu.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8d9742025e63892c2f1a77c9f4e8dea1b4eb0e551349855afc2eb9b55c68f50a" => :catalina
    sha256 "e1fe807091f485642c81c4289c153ca402c8b2729eee12f1f3394662ad8b89b4" => :mojave
    sha256 "0a47b9636e687252c399a7c8820cb168fa2f5fb00281c6c7808c5df767b320a9" => :high_sierra
    sha256 "1ff25b427da3158fb382efb6a8f0b03015c789f9fb56e1e5c2bf4311b51c5c24" => :sierra
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
