class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.8.tar.gz"
  sha256 "1eb9f15096f839f6cd8581cf8b4a427de3dcdcd1d2d76dbc3e7d933e637ccd71"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "8b62829c85bdadaa6e580778908cc35f77cc2c77ad8d087b24faa3e63809278a"
    sha256 arm64_ventura: "028634a8e7da865ba9c30f56ec4db6464c68f5c6d02de0a83bc20ddb0c9efd78"
    sha256 sonoma:        "911929b594cd54ca72270cc27aa58496662d885b27eb290973cfe37815f9c985"
    sha256 ventura:       "90343b750d2dc752fa579f0d34135e8681b313bc17a07c4d580219aac3a0b943"
    sha256 x86_64_linux:  "970e8d4f63b3d6a1b0ad4f151669f5c3844ae2e0cdaed99c298bd83263cc54ab"
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
