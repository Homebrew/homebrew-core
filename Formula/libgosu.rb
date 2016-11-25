class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.10.7.tar.gz"
  sha256 "31aedcb570a36c344b9a3c12ea13596f994cb52a6fb8c15b8ed83058d9cabe27"

  head do
    url "https://github.com/gosu/gosu.git"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    mkdir "cmake/build"
    cd "cmake/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    Pathname("test.cpp").write <<-EOS.undent
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480, false)
          {
              setCaption(L\"Hello World!\");
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++11"
  end
end
