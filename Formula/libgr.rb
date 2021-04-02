class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.57.1.tar.gz"
  sha256 "70a1dfd8b739df616320523a1ceda5d455264daf438e42188ad72f7ba796e67c"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "5c9f23145ca30c04390e348fa3ff655df34ea1528b71d511c75ad6894adb2bd5"
    sha256 big_sur:       "33e4d17a7f7323b69de94f76f954da539ea051b357ebabcad8d5e5b96f893b9e"
    sha256 catalina:      "871d1395a01f4f8e6e50df7eb0937db6edc77047e9efe7699b2a8671338214b0"
    sha256 mojave:        "84bb9cee74f54280ef1c20c8af3993cad7f47759065a788838a32714474084bc"
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
