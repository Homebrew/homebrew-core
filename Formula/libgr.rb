class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.8.tar.gz"
  sha256 "01f235c0f74509a9d6ad8720156835729d386ad2f447cd24dcb536ca384c9ed9"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "f7a270c7ceba9d4fba02997ce21938d57ee56e694df539d5c45d99203bac35b0"
    sha256 arm64_monterey: "d2771f405d73237f9cc49c5b29ca7106f19b2045a919daaad06727f5b5f35c0d"
    sha256 arm64_big_sur:  "9ed0328a86c1f81a1448c12dbe135d589425596c12c6d13310a62ab096137ce8"
    sha256 ventura:        "662a96a4f1ffbbf731fc888492943c7baa43250e6fcfb2755f7cfe14953e153d"
    sha256 monterey:       "ad6c0eb9b10b887a2195f740af47f4f62c69bad87ea3cee5968dcc24c674fbf5"
    sha256 big_sur:        "b613a44bb0824d745d5dd00151aa4c314acfe167afae1ad41bb13d4c3033caf7"
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
