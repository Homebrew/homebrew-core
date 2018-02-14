class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.13.2.tar.gz"
  sha256 "b14b6d2875b3bb1d6f2d89a8eac9d353bb5d7367f4b492c5d98a39db278088de"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "01797e21a5f011c39d433aee18554d6f6d32c05a1364e741cf0d9922d5506fe4" => :high_sierra
    sha256 "4353780840f016c78450906656ababa049838cf321b64b281a0690ad4cc0f177" => :sierra
    sha256 "5a0bd96df55379751fbd50c288e5d54dd3eddc84dca1ad73fce33f16413eb684" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "../cmake", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption(\"Hello World!\");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++11"
    system "./test"
  end
end
