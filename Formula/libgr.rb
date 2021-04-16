class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.57.2.tar.gz"
  sha256 "74ad5a5d1f2d81a91d2ed65259902811df6db0fb4cec749efd8c57fcf6fd3ad4"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_big_sur: "6c66283e9c990e1077410f05c7b495f5ea6029cf2aa3969585ff5df8493d853f"
    sha256 big_sur:       "f9ef234e5777c8efd0e8ac3bd3a9ed8ff4c5eb2a6750fe5724b44e85fb0381bb"
    sha256 catalina:      "36cddfa4f023961816b41dd1593dd7db3bcc621541d9c6493dc0cc6af76c6170"
    sha256 mojave:        "daa503a2a9e1c8307ce062c581405f910f0da7369d3ab378842303544b3ee672"
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
