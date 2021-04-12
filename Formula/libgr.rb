class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.57.2.tar.gz"
  sha256 "74ad5a5d1f2d81a91d2ed65259902811df6db0fb4cec749efd8c57fcf6fd3ad4"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_big_sur: "4c73372e247bc303592ff6b6337661ae8791cbdcabf83156a13c5b9439b15796"
    sha256 big_sur:       "d90e74eee165651ffb7f1a5be947650f0c07b79b8920096484a4c3016803c9cb"
    sha256 catalina:      "39f26858f045a4671c4dff817228f5e31707aac4421c7f5f8245fc9a73d57d75"
    sha256 mojave:        "a8233775b3e7d8671f66c9467caedb48339de02db2ebba00fa20def449763f07"
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
