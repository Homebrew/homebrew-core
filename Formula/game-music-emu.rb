class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.2.tar.xz"
  sha256 "5046cb471d422dbe948b5f5dd4e5552aaef52a0899c4b2688e5a68a556af7342"
  head "https://bitbucket.org/mpyne/game-music-emu.git"

  bottle do
    cellar :any
    sha256 "5a5d6931476c23ab2542af2206e13486ada649b4e5a02ea9e07325bf9bfd64e1" => :high_sierra
    sha256 "2f6a1e59526c952ae8c231adcf71f928bec5c11d35760d4d7def6a3c2477339b" => :sierra
    sha256 "706653420e17c230ae1763da921c8ab08ace7f2db42dfbfd983746074e26b12d" => :el_capitan
    sha256 "b9bba2cd313e782b126cd934acfab5ee801b55d887d6360c6f36c9843dec1c41" => :yosemite
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
