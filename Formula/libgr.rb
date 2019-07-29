class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.37.0.tar.gz"
  sha256 "9120c4215cd2c10239f45f4cbf79dcb199a9e7e3bbbf36e5ce8f4e5eb2e70e24"

  bottle do
    sha256 "cf43f68b60d8c2084f84e35fc66daa8d88b66b13b2380bee6b7807d622f440ef" => :mojave
    sha256 "66e7569c1ab5112a958b7d986ce0aae23ca939d40d6967707d0806bd64d479e8" => :high_sierra
    sha256 "00a6481d88b6c4dc5d1557ae8b249521009234410e2d546d5d39e0013acd4645" => :sierra
  end

  depends_on :xcode => :build
  depends_on "cairo"

  def install
    system "make", "self", "GRDIR=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
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
