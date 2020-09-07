class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.52.0.tar.gz"
  sha256 "8c9149377bfd3fe61b05cda34b980f894f1a723d7c74c4ace5da2e31d3630870"
  license "MIT"

  bottle do
    sha256 "530c9db2560c4b7f75e1ef6e3280d0246889d2707e9326406ad9d22d2e3dceb0" => :catalina
    sha256 "26cfa2787105c17c79027c96acc39fd04a3716c65810edd72dc83cf19f81a155" => :mojave
    sha256 "beaa733249692d24749156ad652ac3a3144cbd4e571e639c2088bb6331b1598b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build"
    cd "build" do
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
