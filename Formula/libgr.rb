class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.51.1.tar.gz"
  sha256 "25e36908d4a78e21be465194a8678d60190d7ac7a972c55c465d820d7c56a0bb"
  license "MIT"

  bottle do
    sha256 "a4d4d644ae080d529e74046a107241d143b7dda6eae6277a617d39f34c1633c9" => :catalina
    sha256 "344c19e9b8ca1986ea591e214dd7d0af641b32be3fcee7396d4ffd31aefb9570" => :mojave
    sha256 "3ccecef65e33653c4cbc6a9958dd439c996e3aa5c955337df75efcb43d14fdc8" => :high_sierra
  end

  depends_on xcode: :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qt"
  depends_on "zeromq"

  def install
    # TODO: Remove this when released archive includes
    # the fix of https://github.com/sciapp/gr/pull/101 .
    ENV.deparallelize
    system "make", "GRDIR=#{prefix}"
    system "make", "GRDIR=#{prefix}", "install"
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
