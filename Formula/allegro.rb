class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.8.0/allegro-5.2.8.0.tar.gz"
  sha256 "089fcbfab0543caa282cd61bd364793d0929876e3d2bf629380ae77b014e4aa4"
  license "Zlib"
  revision 2
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "767b880d9f35d12373a635578af1402c5b7d97b4d5fa593634592142da23005f"
    sha256 cellar: :any,                 arm64_monterey: "682fd6cdea13cffd8c110b6b1c9b7e29069bb2d9512fe844312e31c5ec75ef7d"
    sha256 cellar: :any,                 arm64_big_sur:  "14b1fc80e206b3de73587af7d80a263bbbf590aecfde59bb969e0a960b8c493e"
    sha256 cellar: :any,                 ventura:        "f48100e5de55327d2a3cc92e47fb8afb1d146cfea7764de4b90278bf4b967431"
    sha256 cellar: :any,                 monterey:       "f81cb442d6555108894de9c4b57c0bbb688b9952789bbdfb2125d740219bb766"
    sha256 cellar: :any,                 big_sur:        "faaffa7b7fc9c685cb21a7b03ea26a334b615875db6d2dc8a184b24218e787e9"
    sha256 cellar: :any,                 catalina:       "d4a9c21e7b0ea0ef1d10ef78b100ac2f7cf4e8098dc1a0a4a7c52f90beb11bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cff9c4efe355b2e4d679a36ebdaef40c663524908e5fbad864610c13376ce2b0"
  end

  depends_on "cmake" => :build
  depends_on "dumb"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
  depends_on "webp"

  on_linux do
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  fails_with gcc: "5"

  def install
    cmake_args = std_cmake_args + %W[
      -DWANT_DOCS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"allegro_test.cpp").write <<~EOS
      #include <assert.h>
      #include <allegro5/allegro5.h>

      int main(int n, char** c) {
        if (!al_init()) {
          return 1;
        }
        return 0;
      }
    EOS

    system ENV.cxx, "allegro_test.cpp", "-I#{include}", "-L#{lib}",
                    "-lallegro", "-lallegro_main", "-o", "allegro_test"
    system "./allegro_test"
  end
end
