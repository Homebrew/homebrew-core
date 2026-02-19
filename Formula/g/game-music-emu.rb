class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://github.com/libgme/game-music-emu"
  url "https://github.com/libgme/game-music-emu/archive/refs/tags/0.6.4.tar.gz"
  sha256 "f2360feb5a32ace226c583df4faf6eff74145c81264aaea11e17a1af2f6f101a"
  license one_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  head "https://github.com/libgme/game-music-emu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cad7f27befc7e783d32d9d69167f02612e161f6821af168960442067e93c3f6"
    sha256 cellar: :any,                 arm64_sequoia: "0cc376bae52b30b1e0c72a44b69cb0a04e36da4378bb774f660a401f38adf2d8"
    sha256 cellar: :any,                 arm64_sonoma:  "5f744556ffa8af626454d406f7139ced8a46c1e6a8cb50789c8848a47626e5a8"
    sha256 cellar: :any,                 sonoma:        "8c403e2dbd363c1b5b72a24ebf8e7f994608a6657468b22ef7d3dc738935c214"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81c70c227ec71617513c94601116e8c1a40ccda60ac92c7785366814669042f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffc28bb91c6ca56f35eed5acc08c84808d8f54864952268c15b514e43f3c5960"
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
