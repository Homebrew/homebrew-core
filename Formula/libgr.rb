class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.5.tar.gz"
  sha256 "3f3ff8c9ba74cd92187e89e4f0443696f31e34ec49dabca684c07a38aef83751"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "1fa9a696a362a58bbad27b187b9433d42b5783c3e655767b0280e513d5dfd049"
    sha256 arm64_monterey: "42ba784e16516db611fcc6acd72ae7e209e0906ea34a3d86a870bb7e2f9065ae"
    sha256 arm64_big_sur:  "b45dbb9f6ec110f912d1448783c2694ca4ea41fa7ab73209425744b710351175"
    sha256 ventura:        "b7d9770907be0bf0d220d3f5b5fa77d41f65cd3d0a3d8ef10607ce77f6385e44"
    sha256 monterey:       "55157425dcda6b46b3e186adc55175af08858aba684cf6463b2d19c27f395ffc"
    sha256 big_sur:        "8c6b3f3196336b88c4b487ef3714424fa46c94d1d717bbc893ea47a392556db6"
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
