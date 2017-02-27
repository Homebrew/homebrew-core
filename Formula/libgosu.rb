class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.11.2.tar.gz"
  sha256 "51fb0ddf6c5e3d091e600d31f315288ffc47995cd191062fb3693cdddbcd5406"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "ffb5a6cb87b091b79a93485c2babd696de3ac6e6b5f34ba79a9b3652a61c3680" => :sierra
    sha256 "ec47ed58705eda7bbdbcd3d12574d83e13db405fb29b0aa8c854b7a5725791d1" => :el_capitan
    sha256 "d50aef1a5ef730e75ffc1fba481723de484234461eaf0d271a610cfbd0a7827c" => :yosemite
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
