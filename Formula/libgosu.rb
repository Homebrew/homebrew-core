class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.11.1.tar.gz"
  sha256 "950628903f4c0c5e7c875b5c22fd33efdf93593176c067d17fbc0591b3e1f699"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "7d423497c86b273a54582ad1b602fa4ac03ad8d0f12a7a38cafd431e6821e9a9" => :sierra
    sha256 "ebe2a6d433a56e15a6a7b27c6012603b7e55ecec577c956e1555bccbed074e63" => :el_capitan
    sha256 "83f779ee9e57d0185817d66f608333435f578abb5e655f22bcfaa12d00d08ec9" => :yosemite
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
