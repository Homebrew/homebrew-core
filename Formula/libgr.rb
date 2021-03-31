class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.57.0.tar.gz"
  sha256 "d90583ee899d2dfecf23ad0008aff595d8973aa39ce02f611bf66122caec7988"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "e961feb02684a6ab2f02378ca7e0f2beed8fe9c95d7f97e2c27902c9838f3338"
    sha256 big_sur:       "df765b80133378f2d1c90da0b7a3732bf3e3259899433bc876326bdb07e9f432"
    sha256 catalina:      "8c7e22c1aac7e6adcef7411e30e23c7db0d79ff2c0f83be24c9eb89323876b25"
    sha256 mojave:        "f771bd64240d5c5f8b0a80a285c14ab2f3e526c62ba0d89dda20df44a5cc7f2d"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt@5"
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
