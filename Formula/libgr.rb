class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.63.1.tar.gz"
  sha256 "754e4497284d879dea02244ce1a31461f2d78bc4a1195ef6ec16d2696e1d7e09"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "62d6f9dbda81ec5a75c5fd610343558222c5f55b65f6f13c2300071ad943f252"
    sha256 arm64_big_sur:  "efe83b1c7545459925e0576d3c89f8deb78336bcdd36201e026900d5344d7165"
    sha256 big_sur:        "dd5b91977e2f8cc117286cacba3015c052bdae647568ec0608d67cdd04ea6c01"
    sha256 catalina:       "b71d236c4ffc3856b00e87e8bf30e989bba5a324d095e81e72f45925b92b0a26"
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
