class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.19.tar.gz"
  sha256 "70dc02ca46230d1a5b7e63a8054f1c740cbbfa819e398c1d305d71668e31c1f4"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "22a846eb6dfdd38de88ea6344617f8f583d3f9fb0ee9a3ff6ee78e897fcdd7c7"
    sha256 arm64_sequoia: "66f8e48ad2ada951cf7ba387a96178b32b2ed3cc41eac251b98cba1e47197b52"
    sha256 arm64_sonoma:  "aaaf9cf712f028bdce9d91d0028b0ae6ac38e472e824b0c0c3ced9e66e5e00c3"
    sha256 sonoma:        "14fa77e067ebdcbec5663d5d2c5ea7ea338b0d15a1d25383e1a2fc9a3a1b5014"
    sha256 arm64_linux:   "b676ddc0e1a6acbb88703f5a1b4e0069be65a470bf840d2809d8e651b15ebb66"
    sha256 x86_64_linux:  "7eb319d8559144596471b2709a3a3f974168b92b9c7fc2c3343d9c3921989bf2"
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
