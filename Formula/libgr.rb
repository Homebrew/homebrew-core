class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.2.tar.gz"
  sha256 "1b6f05a0e1043ef00998fa9bec120c90a01220551e9b094653a56ee38a4bbd1c"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "66f66d62fcbe109665147b42d111e9b5735a3b851e0b50b12a327caa6e902421"
    sha256 arm64_monterey: "8ea5a3a589f3f8b419876bff53d2a07deff964ee4a6503d6a1ea7b5fa5bd96a8"
    sha256 arm64_big_sur:  "e16a7a5d9929f40bc974e4220f3d141c6b6eac1c349f3b1c0c0a7d52c5b86394"
    sha256 ventura:        "ca9f9bfa1bec27e1edf928efb7b1c46ab308729776d89e0454167845bba79a5b"
    sha256 monterey:       "ae9cb48a3ffdfe2946cf9775204c8ba44088b8b790257f87c2af51a9d9c8ed9d"
    sha256 big_sur:        "87d15bfabe97db035319dd661bb381a73b0fc2f3675b959c98b4c220224b88c8"
    sha256 catalina:       "5341c7e431c10a56b61e5552740f7f31bb69e433f075b40121b25cbad2547891"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
          gr_activatews(1);
          double x[] = {0, 0.2, 0.4, 0.6, 0.8, 1.0};
          double y[] = {0.3, 0.5, 0.4, 0.2, 0.6, 0.7};
          gr_polyline(6, x, y);
          gr_axes(gr_tick(0, 1), gr_tick(0, 1), 0, 0, 1, 1, -0.01);
          gr_updatews();
          gr_emergencyclosegks();
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_predicate testpath/"test.png", :exist?
  end
end
