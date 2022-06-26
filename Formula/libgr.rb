class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.64.4.tar.gz"
  sha256 "b9866f1c9496817023c0d7f23d92bf7c5bdcbe669a1e744a7e839b5f34baf501"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "939165ec39e9aaec3fa8d7cc0327c126bca3f717350600a527ff3aa8c0b0cc11"
    sha256 arm64_big_sur:  "e486226c142c6df6bbc853196a30f82256d6404d56e39f0b1a9b2b40bdeb9428"
    sha256 monterey:       "75bd2654a9e4fce027c3aea44fc86a690474ac982420a5bf4e2933029411aa2f"
    sha256 big_sur:        "85986b4d5eff47fa9372a5c7ab11be2fefbd3884da900e687cc88fa183e617f0"
    sha256 catalina:       "17c2187cc877e24cabbe8439eb748b29fe834d67cc9496aa8dec6045f4effbc1"
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
