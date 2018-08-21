class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.13.3.tar.gz"
  sha256 "2ff0f1ed31aa5b8c2763577b9a27cf315bff30d3405fcb4661909e67163add01"
  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "9761ae6de5a6c2b93b67ca3891e0e2bbcec9659270c5083adce2bf2cb46d3e2c" => :mojave
    sha256 "3630e9cf325de71b57cb8353797da6c46ef27e0310ab704a86a68a424cf4d908" => :high_sierra
    sha256 "471b6470e480332ab0b69946fbcf526ddf0e4d39d5ebfa27624bc2d4a614a31c" => :sierra
    sha256 "79a59bd09dd302ec10e3ad36fb6920e877628b0047011efa2a9f748e90d6dd96" => :el_capitan
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
