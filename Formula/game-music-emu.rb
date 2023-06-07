class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.3.tar.xz"
  sha256 "aba34e53ef0ec6a34b58b84e28bf8cfbccee6585cebca25333604c35db3e051d"
  license one_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2
  head "https://bitbucket.org/mpyne/game-music-emu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c33d21ce67a78b16cfe0e2e68372c62df99bec7d7c73ee20e9acece876ae2e0b"
    sha256 cellar: :any,                 arm64_monterey: "1346614b5a9561f7eaace297b5493eeb99ec4c3e561acc65669ca6dbb0cd6793"
    sha256 cellar: :any,                 arm64_big_sur:  "e83fbee26086cc93f7d2eed7d3b93f00a0a0c9eb9d59abf3aba91216fe89d3d8"
    sha256 cellar: :any,                 ventura:        "7b686c42bec0fd89a976842ca616e41b8c40883d461faf49da21409e96585cb6"
    sha256 cellar: :any,                 monterey:       "7b1e5a6934c8ff16fff726c1963e465abd11458f5773f26b38ce8771da3289a1"
    sha256 cellar: :any,                 big_sur:        "a0abdc4c5ae05ea22ad3627a1a717ed8a1a137065188b995858c0f301dfda640"
    sha256 cellar: :any,                 catalina:       "ee658e16c3d9d0061b0b930ca387a1cb2fa6b6b50d23c9f6f4ae7799ddb6f46d"
    sha256 cellar: :any,                 mojave:         "754ab0c8bc0a6de76adcb56a59913c930196e8e44154958081c093fb7763edad"
    sha256 cellar: :any,                 high_sierra:    "596497823bb1ebb30f20fa01c8656bb15544c12fad5d67c4de165f9ef3122e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b3b37367e9fada0881a14a96a8970eecb79426a378d02dc7ed8881923096f3"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_UBSAN=OFF"
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

    if OS.mac?
      ubsan_libdir = Dir["#{MacOS::CLT::PKG_PATH}/usr/lib/clang/*/lib/darwin"].first
      rpath = "-Wl,-rpath,#{ubsan_libdir}"
    end

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", *(rpath if OS.mac?),
                   "-lgme", "-o", "test", *ENV.cflags.to_s.split
    system "./test"
  end
end
