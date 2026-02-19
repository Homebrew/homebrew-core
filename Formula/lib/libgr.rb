class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.22.tar.gz"
  sha256 "528872d82f313517b80ac9233300f6fa9a3083f98ef25585f77260e8985b8263"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d7dc038e293663cee2a5990ca42166e39867635adb9e4dc3883f71a565475cb9"
    sha256 arm64_sequoia: "9dce0ae2d6360be21b8d584e85b033974ec52dec147b4ba77e8c038339666195"
    sha256 arm64_sonoma:  "541b3104205a8a15bb0b087ed0cad19c1f8b6da30ad4d01fe91f3641169bce4c"
    sha256 sonoma:        "383cd0f10a50823f81e880aef13c53c29010844d0114deb796d83aafccd7a63e"
    sha256 arm64_linux:   "91a6e07a239d15244be9cba1dd5036090d7d3e172096a66274afb933f2f27e2c"
    sha256 x86_64_linux:  "1fa9efb8a2260fc116e848f6996bf8b6699d65bee20537a02c7716d3ddd37d28"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"
  depends_on "qhull"
  depends_on "qtbase"
  depends_on "zeromq"

  on_linux do
    depends_on "libx11"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_path_exists testpath/"test.png"
  end
end
