class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.58.1.tar.gz"
  sha256 "6bf66fb3f5cb55ccae2f9577b6c6f82443d9cb1e29e9992371a0beae15dfbc0d"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "1bc2855ded2b014065c9a732fe5e8117f8033a3d6f9b4f40c9f590ec0cd006c3"
    sha256 big_sur:       "f031867f149c470e837b314ca1fa78b009d19ff7394d5c06803796f9b2334e1f"
    sha256 catalina:      "bc46224f56b921505eb3f68eaa02c640f9342508d4ca4cd991f93199f72ecf1c"
    sha256 mojave:        "d60b8f7a34effe19db6f9f4757bd8263893648ece152bcf2023e8a03a82e995f"
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
