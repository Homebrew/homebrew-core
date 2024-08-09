class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.7.tar.gz"
  sha256 "2584727b1413a337ef14daae1e61bdc5c946403031695b42ecfbf8bc1888d132"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "4471760a40d20c1eb0d1fa65fed678e6e37d66afe0fdadd0aa9fd4b0f6e7322f"
    sha256 arm64_ventura:  "370d2ce18f6706f4c7ce9577c99efb4aa781429186d2e506897497e0d9054397"
    sha256 arm64_monterey: "7071d26de1baf237f7fa72be8fcbe732c377b30b4b974c8c13fed86459a836ef"
    sha256 sonoma:         "cad628cd58e7b8168d18a63b88947720236861b0d5838d36bd60df89ee6e59a0"
    sha256 ventura:        "c12411fc3f1e60f1f5d4d79b8846cf0ddc9a3ec5fbb2cf4db31cd9a140c09b7f"
    sha256 monterey:       "ba798422f8b3d7fa987c8c4e7f44ddd6d248c81501c989cb75b72ba104c68bcc"
    sha256 x86_64_linux:   "cf780f036ec41d094e62928cc6e85067a68ad7915515da9ffe2e7f83d09b5f8a"
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
