class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.0.tar.gz"
  sha256 "308885b560d2ee70f8c43e8bb2b38ac4be5f2d6233cbd304193bd0648a661537"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "7872614a37cb0e23e565284df482b14b5353fa906f69b28df968737cbc7791c0"
    sha256 arm64_monterey: "d69f82202fa35b0e846bd48bf0002a551c37c1a87ebaa3e3babdac11510171fe"
    sha256 arm64_big_sur:  "72079e824e60d450d18433ea6b49f719093c9da37bc2a1daf416e24c408deba5"
    sha256 monterey:       "f5473f45649ba4458e3f84169641e3aa133659cd952ae1f9bbaea350a831e597"
    sha256 big_sur:        "b40abdf3b9b69949099f7bddf3b588d2db761dc153f82769238f15885556c422"
    sha256 catalina:       "ab792634dd6748291d8b0748f36a2c9f85e67d74b1c496abc5ced6e9424fd3a8"
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
