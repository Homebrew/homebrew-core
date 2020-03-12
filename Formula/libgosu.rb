class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.15.1.tar.gz"
  sha256 "9a171be43eb674b8a1b704d5540ebe24070ff0796a1ac54cd1b0c8f4e0dbffb8"
  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "2987fae82e7ddd8d31d63ddbabb6f393291d3f7fc8b4385e14923351953a39d7" => :catalina
    sha256 "41ff8f6c875627b683e7d2416f0429f268b6dd045ad5eab1e0b5dbda2890871b" => :mojave
    sha256 "5ddfc5984da04fd2072c72bd673e58f2f9266dd45ab455fcfc9de7f97918a841" => :high_sierra
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
