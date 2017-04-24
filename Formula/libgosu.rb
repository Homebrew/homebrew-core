class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.12.0.tar.gz"
  sha256 "aa726e7da57eb4671ff19a198e7015c1899e0536b0152e7375a949c7216ef90c"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "6b71fbca136a0677314cd40a274b552849ec3d6a584c09e8d60dbaddb28e9786" => :sierra
    sha256 "86f44821f648eed20c1f686ba5b35f9f307be225615bfbd563a37fbb95327d43" => :el_capitan
    sha256 "aa127db04dcbd378c9bd4367f37398b1d6f252c8d503e923074632c9b72e97d7" => :yosemite
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
