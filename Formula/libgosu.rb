class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.11.3.tar.gz"
  sha256 "faae9245c7b016a7f8dc8fe941b6bcdce93b219c58e4bdcfce2a26455d4755cc"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "56038b7f65a80e6a491d572b02eb04d59a93b04e102b72f74c6b16e8cb3dab12" => :sierra
    sha256 "e1a31413ac54cc2963da75641d53194ca56bedfd33a0290790776659c326b5ca" => :el_capitan
    sha256 "c1af350af10e5a4261097e929e17801cde54b11299837a7e7ee95454fae07ee4" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
