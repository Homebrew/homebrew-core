class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.10.7.tar.gz"
  sha256 "31aedcb570a36c344b9a3c12ea13596f994cb52a6fb8c15b8ed83058d9cabe27"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "d85229625f2e42f302e92458d05f9f0bee06bfc0749b89bd522df94a0192c70c" => :sierra
    sha256 "47d5769674bee09c63a2f684b86d8a8817a4e8fe419b0476b43afa46ae739fec" => :el_capitan
    sha256 "429c8b41ad260fe453a0130c534fc76c6a679f3089ab162aa4f0c854b5c51808" => :yosemite
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
          :   Gosu::Window(640, 480, false)
          {
              setCaption(L\"Hello World!\");
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
