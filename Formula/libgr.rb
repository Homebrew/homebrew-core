class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.62.0.tar.gz"
  sha256 "871a4c57572567727831038274d0a28a2272c73a2f8e5b5b72cc856077c135ea"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "be517d6acbcfb81dd1c59fe192e25d36209baa1130d1a56d358b03fddf060bc0"
    sha256 arm64_big_sur:  "d3bd57f688f15fb50eb233480fa974e26100fafb0c9f9b3a1305c1784fb09eb7"
    sha256 big_sur:        "e76d285e8b69be759d832e57f0e6ece113b0dc1e64b9d4c5e4794cc8d9382acc"
    sha256 catalina:       "604af96a67f8376bd166c5107eb4ada9fbd12dbe9345432f153dceec1a693f98"
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
