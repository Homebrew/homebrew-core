class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://github.com/libgme/game-music-emu"
  url "https://github.com/libgme/game-music-emu/archive/refs/tags/0.6.4.tar.gz"
  sha256 "f2360feb5a32ace226c583df4faf6eff74145c81264aaea11e17a1af2f6f101a"
  license one_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  head "https://github.com/libgme/game-music-emu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fec1c3298b4ab969c7ce7af833b01193f7466d5b3616db916659904f53dde31b"
    sha256 cellar: :any,                 arm64_sequoia: "660ece50d8af5ffbff406371638895522a4ea69d411b1258eb8fdba0a4196adb"
    sha256 cellar: :any,                 arm64_sonoma:  "47347ae4155ee458e69431d455c026ef63b891c3c5e0f4728482b6a257ce4d81"
    sha256 cellar: :any,                 arm64_ventura: "2b87dd4bdc42dbf1ec68ee2820867ea587c8d9847dc93e549e246551b63d7ef9"
    sha256 cellar: :any,                 sonoma:        "3a3d79c0aec9aba49bb111c756ca7e401b63d38231fff82dfda9576c6314cec3"
    sha256 cellar: :any,                 ventura:       "3a41c99cffbd79c112d268af85076d02ae15d32567870ba22fecf1b5fd8f729f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0285d768bbae8994f2a70b95d8404956915c51063076cffd3ef92ad74e0d59d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "074f9d6dd549ce40b90ff8a91f2bbf1a39b6b2dc26e88a244b20423ad4bf06d0"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

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
