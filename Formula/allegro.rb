class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.8.0/allegro-5.2.8.0.tar.gz"
  sha256 "089fcbfab0543caa282cd61bd364793d0929876e3d2bf629380ae77b014e4aa4"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3995b983d76331b0e7d61b5e85504e04496e63c57ad22c96a91a6b8c7677989c"
    sha256 cellar: :any,                 arm64_big_sur:  "111f5e8474a0abd37641c2db543664b53f89d83201493a6e22d846a25290a16e"
    sha256 cellar: :any,                 monterey:       "2701bd5309623abe46a268fbc9567c37bf2465f0dfe52de737bd24273f5dbf64"
    sha256 cellar: :any,                 big_sur:        "d681ad8e081082bbb8ac3036b4697ce03cbfc139037977c3d45880cd3b9f8396"
    sha256 cellar: :any,                 catalina:       "dc2b03c9441a55e8501a1e330a1c0d673756ca06efbbcd8970012ace01c7d232"
    sha256 cellar: :any,                 mojave:         "b9b9dfdb3d26e50ee7f67a678fb20c6874366fe9eeeaf1300b6fb020050e6b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8044df31111ea3e4f3aba7a28e12a690cd91d19b21374387d962934fa82c67b8"
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
    depends_on "gcc"
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

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lallegro", "-lallegro_main",
                    "-o", "allegro_test", "allegro_test.cpp"
    system "./allegro_test"
  end
end
