class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.1.0.tar.gz"
  sha256 "41c69ad9d710d2edad96a7bcff351a9d1880cb637e535c5c8b43d551d6651c94"
  license "MIT"
  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "ddecd4c4e7e5efae176564fe284fa28ea0d2ca036307275746cc89ebfcfec465" => :big_sur
    sha256 "0a069eed6b4818492b6f17529bf410016e718fec02083057b7fd69bee82ba222" => :arm64_big_sur
    sha256 "333e8f988f9684060721d0ea90fdd2d9c4fae1464f71dc36ea214894459c062a" => :catalina
    sha256 "45d11a2ac6b2a24f5c2dac4c631bc0c4bdcdae59061534b70598431a5e1b7496" => :mojave
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
