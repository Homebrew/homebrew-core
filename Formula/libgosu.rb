class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.15.2.tar.gz"
  sha256 "e2cf7fd9bc22348e73109c4442f19550fe4f7cc6218525379c68c12308646f42"
  license "MIT"
  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "434d168198e19a69094d63e049fa384b54d5ccd1c0142dc3c65d13dd508c35c7" => :catalina
    sha256 "af788f4adcf62f8a53c9ce1253d2125fa6871ae1d6ae3c16bb186fad3ff2baa7" => :mojave
    sha256 "86f75871ff7bcb97c723193b1b7f9d835b15d0273a94f897ca9c1e6306bab586" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
