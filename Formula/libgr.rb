class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.47.2.tar.gz"
  sha256 "f7390496ee3f4255346535cfcdf2da102a81c035a5931413fa5da1e2141cba09"

  bottle do
    sha256 "a04d35e2f78a8ae6f1988c6f5428956513975aad300daaa87a0f92c649745f12" => :catalina
    sha256 "02c7cd12e2249f98cac3b4668a1701b7e8a529fbf50c0a6b58c09baff29314b4" => :mojave
    sha256 "0aaf94592a8540a80ec2c06f6a527b721c5abb1b4f8eba48a3de865d76f8f193" => :high_sierra
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
