class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.72.7.tar.gz"
  sha256 "a9c64a8d845d721f9ce4be761486cb7bef8ac06f920c9ef0f9f15f980565de61"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "31476e772953ba6ea0c5e9f389da2941c2192f1a097ca421d3ce20079d71ea2f"
    sha256 arm64_monterey: "95ca1fbd259e471f57f191b817e1d6cac89df961965845fd7d442e0869b8bd44"
    sha256 arm64_big_sur:  "c1aa63db5bc4cbd347e1e4c3c5fc04603262ef0979e79252e7c8a6539cbabfb3"
    sha256 ventura:        "10340dbf18c7ad43800ad076597b00e16c8d227f97a7c48a3c337fb5560ca82f"
    sha256 monterey:       "0d75b9ce207714e0de44a1d97997e5427be5986b1859d2b4be3799cf69855a13"
    sha256 big_sur:        "6010984cf43fb13c4467c80f17809227dae16d028b97860eefa7bd81b10a557c"
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
