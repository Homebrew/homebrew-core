class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.16.tar.gz"
  sha256 "a9eb77caa0b28f46cd7e5c5318a56f75af28c9306fa802fbb10f7b3d332d71a6"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "78ef4c2f85700a0055b133da7be7b0204137577c98ad2da304ccf60f0f6813f3"
    sha256 arm64_ventura: "d47d6eff87e5aa504546c5612c79f0b6a2829cbe6ccb61f18cde7f143a5fb415"
    sha256 sonoma:        "35697aafce1f55e52c564092901cd6d29e278e65267f009d02d5ce38ec99d423"
    sha256 ventura:       "7aa0b7f1aa20a9b7dce302339aa27eb8101f350b7aefb61ae7d36c8c98aeff7c"
    sha256 x86_64_linux:  "a0d2ea23a2e2041d57525c8bce1f1566b32945b2c8f147a12394f5e02f15cee1"
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
