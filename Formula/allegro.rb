class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.7.0/allegro-5.2.7.0.tar.gz"
  sha256 "c1e3b319d99cb453b39d393572ba2b9f3de42a96de424aee7d4a1abceaaa970c"
  license "Zlib"
  head "https://github.com/liballeg/allegro5.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "111f5e8474a0abd37641c2db543664b53f89d83201493a6e22d846a25290a16e"
    sha256 cellar: :any, big_sur:       "d681ad8e081082bbb8ac3036b4697ce03cbfc139037977c3d45880cd3b9f8396"
    sha256 cellar: :any, catalina:      "dc2b03c9441a55e8501a1e330a1c0d673756ca06efbbcd8970012ace01c7d232"
    sha256 cellar: :any, mojave:        "b9b9dfdb3d26e50ee7f67a678fb20c6874366fe9eeeaf1300b6fb020050e6b37"
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

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DWANT_DOCS=OFF"
      system "make", "install"
    end
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
