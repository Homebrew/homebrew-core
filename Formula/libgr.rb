class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.57.2.tar.gz"
  sha256 "74ad5a5d1f2d81a91d2ed65259902811df6db0fb4cec749efd8c57fcf6fd3ad4"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "554adf00c68e0cded7fdbf25d368e6eab2eef6081588e4f9176ac5dbb165929c"
    sha256 big_sur:       "81a5949b3311556a9c25b9796a1a83dcb37ef457c31bf7b3ca95a7e2347c3713"
    sha256 catalina:      "ecccdef19fc49b13b05dbae285d3767ebab9ee9dfd09a51c3335d1d1ae0a2242"
    sha256 mojave:        "9938b54c1452e30c0dc9f346afb2a1e49516407d09a7861c928b303edfa5d8f4"
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
