class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.63.1.tar.gz"
  sha256 "754e4497284d879dea02244ce1a31461f2d78bc4a1195ef6ec16d2696e1d7e09"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "20cc408c7ca3d6e89ea0f206a50f9a96991c8446dcebb1ffb1711e802ab38e16"
    sha256 arm64_big_sur:  "db6729eb2c981224dce81715caade57c7996d04a3fee2bc49b7fb1ab3c670b62"
    sha256 big_sur:        "c920f626b39e35a2446f62333f8bd105cb795afe689bd84e83f55fadcac2a53e"
    sha256 catalina:       "97e1b3abb19b22446cbbc13fc1b72358e19cc0cf6e6102ec356f4adc2cc6a0d3"
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
