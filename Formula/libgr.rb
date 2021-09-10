class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.59.0.tar.gz"
  sha256 "9027bceebd171641bb3f0c35398ddef529beea3c1cd6dc79dad18268f9cda50a"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "1d9b2e1e142e7d19b4fbd305ec2c061806195937232ecfb36998c76f284b0edc"
    sha256 big_sur:       "364bfd280c221e8b34f07c4e3f6186e40afe8d220b7dc07c90aa2f474183213e"
    sha256 catalina:      "ade9f5cca0ef7f7a066fcf9133bbc0e3c543db3b8e79a1516e0c00d8d6f0c4fa"
    sha256 mojave:        "4b6590cf7553028a32980b4c4ce3f8adfaa837b07bacc86d315cc15defa21b77"
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
