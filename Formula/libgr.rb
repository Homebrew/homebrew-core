class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.44.1.tar.gz"
  sha256 "43979bee9f9bffd145e9e076d1ee24e6ecf3866eb6c0e34631da922bfb4dc0b5"

  bottle do
    sha256 "6e63cad1e7182a29eeab76efbc9775dea73faf2301a0c2a88e14d9e24ce1bb0d" => :catalina
    sha256 "0b5a7338a81efe60dd9af00b5e912a60ed0e8dcc9476c84b35af1e789cd8d572" => :mojave
    sha256 "d021bd902988273d097af9ffd949a50752611003a2a7591a3a482a96edaf651d" => :high_sierra
  end

  depends_on :xcode => :build
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
