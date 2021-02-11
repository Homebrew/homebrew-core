class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.55.0.tar.gz"
  sha256 "070ca1cb0a54f90446e2cc0a0b331a112e0842e32a000bad2135e26ce09f5787"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_big_sur: "ac99069ce1dea838922beedb4a9bc6cc3c7e9aa2fc77b6e613aba07a7aa22283"
    sha256 big_sur:       "c67802b5256a489bac964a3d6faa6e6434605f3e5e25ade721dff9108918868f"
    sha256 catalina:      "aefce95a107b2463ce65fae151f0196542ce2154187a293b8acef12261f4a2e6"
    sha256 mojave:        "b05cbf4f64def74f618ae3d6c98d8cfc77bd4dcc6704e266e02949348fb4dc9a"
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
