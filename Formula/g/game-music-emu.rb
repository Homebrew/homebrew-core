class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://github.com/libgme/game-music-emu"
  url "https://github.com/libgme/game-music-emu/archive/refs/tags/0.6.5.tar.gz"
  sha256 "8531678502451c2cf04248cda45c8b4645e19fcfb63e6a7ec2549641c47bb392"
  license one_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1
  head "https://github.com/libgme/game-music-emu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19b1c4f3047bfe80135bcafe84bbccb56b9771d36ecb7a5e02d3b9e1595fd395"
    sha256 cellar: :any,                 arm64_sequoia: "0b676cefce47fae8276bbd21f3e446b95f2c87f065bfaf498db2950a404a33d2"
    sha256 cellar: :any,                 arm64_sonoma:  "0b4a845baf5d9a8827eb9a87be3da1f187501641e5c7c0c732dca6a5c140a090"
    sha256 cellar: :any,                 sonoma:        "9408ded8839fe3d477632fc55da1aa4b179100dad3ca8d993f7a957d5f4d734f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "390ae9dba17bc5ab1c6f97c482e75fe870c6647f42b5684be5aa67adb00ce5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab8380ec3254fee092a5d3bc8b5c03bd794cdae031613ec3811fbe9db92d49d7"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DENABLE_UBSAN=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    if OS.mac?
      ubsan_libdir = Dir["#{MacOS::CLT::PKG_PATH}/usr/lib/clang/*/lib/darwin"].first
      rpath = "-Wl,-rpath,#{ubsan_libdir}"
    end

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", *(rpath if OS.mac?),
                   "-lgme", "-o", "test", *ENV.cflags.to_s.split
    system "./test"
  end
end
