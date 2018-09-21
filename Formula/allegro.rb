class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.4.0/allegro-5.2.4.0.tar.gz"
  sha256 "346163d456c5281c3b70271ecf525e1d7c754172aef4bab15803e012b12f2af1"
  head "https://github.com/liballeg/allegro5.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "04a378dc871c98270dd7d2305dfe1373c400a39893e555c6166c13e26d472ba3" => :mojave
    sha256 "bb341c97b4b21ec74bce8c2bd89bb3bd01ab1367eaec595eb597fcdb9411a315" => :high_sierra
    sha256 "e4047f9d5e838c84e1e1774c080b6c66bb75da9794fd677512eb8d8294ea2da1" => :sierra
    sha256 "c98cd152d3be7f0d12e6ba9f06c2cde35d71a3c425ae950fbf22a9ba0c985139" => :el_capitan
  end

  depends_on "cmake" => :build
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
