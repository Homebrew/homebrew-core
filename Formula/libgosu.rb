class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.13.2.tar.gz"
  sha256 "b14b6d2875b3bb1d6f2d89a8eac9d353bb5d7367f4b492c5d98a39db278088de"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "147279fb12ca113b97f6e827ad60e29511c9f68772a9e65f67abdda45a208466" => :high_sierra
    sha256 "03709f8df943c8f5c5d0af68f82722569cec3d248f02bfea224bca9ad3da3acf" => :sierra
    sha256 "f0141f0442da13eeee06b143edba5041d28e4abb1eb285b54d499641df4fc6d6" => :el_capitan
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
