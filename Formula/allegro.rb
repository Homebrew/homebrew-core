class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.6.0/allegro-5.2.6.0.tar.gz"
  sha256 "5de8189ec051e1865f359654f86ec68e2a12a94edd00ad06d1106caa5ff27763"
  head "https://github.com/liballeg/allegro5.git"

  bottle do
    cellar :any
    sha256 "b84ad30a88079bd0e88f40c73bb3b9260d2d713c5dc641b4bf2305f226dc26e2" => :catalina
    sha256 "58517ffcc0689c592e394638aa90477bda3170b33b7c75135871297af8f08efb" => :mojave
    sha256 "8d7e5a4ed33deb9c14b885788cc955b2900dd097d5c7876c3a5373c9746e3c1a" => :high_sierra
    sha256 "c236492cd141af9d1bb9f32122265d444967ba9399b6f848d9721afd78cbb84a" => :sierra
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
