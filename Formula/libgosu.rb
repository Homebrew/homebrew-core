class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.1.1.1.tar.gz"
  sha256 "d450fcf171693e058b396ecc83e123848994419cb5c7326ef3adafc12b591a6f"
  license "MIT"
  head "https://github.com/gosu/gosu.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ba3dc05c5b75e98517f19f8c79b1250905ed45d10470e318fe039950ac98ea10"
    sha256 cellar: :any, big_sur:       "e3743ae931e3fb3e7f2f606d61678a8ea4377b2edd065f3972f5c59fdaed2124"
    sha256 cellar: :any, catalina:      "032761586a702d3ca96cfc9635bb4d6660505c3638127a411a9d5c7faf7a9f3b"
    sha256 cellar: :any, mojave:        "116839d8a24839752bb94c9904351db68d10a3cc33b56968e89f243ca1174675"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
