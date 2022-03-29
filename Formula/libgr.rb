class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.64.1.tar.gz"
  sha256 "bd86856920301e444b1a144f16b239367719b63a87ee07447f0280b6ea1887f2"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "74970ed8d0e0ecec128e79788046311f06b292ad0d4acf684b81d9fa43cc94a1"
    sha256 arm64_big_sur:  "33abc59575fff2d39e71918935fa06d0a60dc563dfe2f61f5ae5b13cd0c3b0ef"
    sha256 monterey:       "d387060cb3d72fc09d73d31ceeb8dda98a04a6808e39572fee414d5bbe6ef2ee"
    sha256 big_sur:        "ed32855aef185d8523fc67cca9c7f677a2e7b55ec1e291fdb8670cf040f384d4"
    sha256 catalina:       "c0409f0bd6d5d34781870147bff6e8970ba36dc4651fe3c7b9c85623b60dcf14"
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
