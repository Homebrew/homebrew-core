class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.53.0.tar.gz"
  sha256 "a348602c3e2d928b5c293a19ed91e126bf56e23720d4f0e12aa92767da767276"
  license "MIT"

  bottle do
    sha256 "dfeb1ddb78fa930adb152ce53389ac1f1b2f700418f1f913694409d916d78aea" => :catalina
    sha256 "6fef3954fec351712e3eade9b8c3b6e9b14a80c9b45d33253cd8729cdf24f7b1" => :mojave
    sha256 "b63afe24fdf74512036b2536796e7e5cf5c1e2716ca980aa9eab64256420e1e3" => :high_sierra
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
