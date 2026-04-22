class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.24.tar.gz"
  sha256 "6cf573ca23cc08e7410355960a36ae9127a4c06241b05341bb974abd2ceb1b32"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "6b92d7f808bdc4f7391e3753a6be77b0e50eb962360379671abec40de1917c60"
    sha256 arm64_sequoia: "4d6cf7eb32443dad295b6d1ce362ffb776a653e5ca3c72b46edaff7aa2c00f6c"
    sha256 arm64_sonoma:  "b800f89319b9fc5a305ba3d5e16b289ce252e1e7c1fd3970af0308b488c06d3b"
    sha256 sonoma:        "1158e51122c0fd6784f580caf840455a3ee249ce5c3335fb5445c97eb1f3344c"
    sha256 arm64_linux:   "a1922f441a7f6c2097859b9ff876c8e8c2147d0be8ea0c86606090a5bb67a0aa"
    sha256 x86_64_linux:  "059ed00ec068a771c925441c64dd1a266f11b4a57f9e9b18e87a4335454c217b"
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
