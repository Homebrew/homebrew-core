class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.13.tar.gz"
  sha256 "a68d4ed2e44a97c475bf18eeed7791af162740df85ca71aef13d23385f3290d5"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "cf218ddf3cef12daf26b7b5c969aed5f5980ccc178212031306ee6457d1267fd"
    sha256 arm64_ventura: "ffa9b70469948f560dcbcb5cabe8a0089fa570354def646fba7a5737b24dad3b"
    sha256 sonoma:        "298825a5c1c9c8f41db6d73e40bce1e296903c89f4a28468589396b3285b963d"
    sha256 ventura:       "0a03511e014048640b502870303c0d8bb1863bedd1551ce27ebaa6d47d542dc0"
    sha256 x86_64_linux:  "5639942221f1c0a863becdcee780828c7f5ba229e4bd8fa97c941e5afa2e1896"
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
  depends_on "qt"
  depends_on "zeromq"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxt"
    depends_on "mesa"
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
