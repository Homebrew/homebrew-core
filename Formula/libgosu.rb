class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.14.5.tar.gz"
  sha256 "4dbc4998e2c630ee7758544de4286c70c68e639524b6088ccdc7b5487c928695"
  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "489d5b6ec58212c098b9ef85daef7174294de0c1b71eb58b676ad9ab2f94cb22" => :mojave
    sha256 "d6d73aec0aebcffb9c7b0e00d2c76d520775610252a17f029e19af2f592b66dc" => :high_sierra
    sha256 "b5d21421120ed980145b171707121664ea48832958292589a8cd17fec477f2e3" => :sierra
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
