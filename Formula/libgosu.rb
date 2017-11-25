class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.13.1.tar.gz"
  sha256 "0861beba7e19cc06042a731845d3ae3b32e88c0856a41930b390b815a7ec6fc7"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "2f1e2b6af5713deb94df795fd7bb8654b779df2fbefba28e7794911fcbe6831e" => :high_sierra
    sha256 "ba99f69d80a093fbf21993dcd4abb02889ff2ad264d43565f408381d308c1b35" => :sierra
    sha256 "16a420796d64dff75ca8aa98cd4e7cb629d34a0c46bf814b23af049c10d6d691" => :el_capitan
    sha256 "fd79a4bdb960d0d08fe812763172f32f3e48e08c5d888d7479dbd8170425cf77" => :yosemite
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
