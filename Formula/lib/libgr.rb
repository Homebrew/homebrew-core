class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.12.tar.gz"
  sha256 "25f45f71d8da2f13ced8ab7627dd4977c24cf4160dedac52d8400a39188b056f"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "aac3a8cfb5067c8ff8a409cf49c2a275de32b543012c7f9ff83bc100a6886214"
    sha256 arm64_ventura: "6bea1ff36c0684bbe43e8e33f87d2ebce7c3123016f2237c57feea3352872865"
    sha256 sonoma:        "2bd46740f010d0020416e942391967acb2769d266342b8e2f6ab90195a0f1e77"
    sha256 ventura:       "d85ec8de0f93dfa6650bc9c8ae6a578b6b057d829a4443a6cdfeace094471062"
    sha256 x86_64_linux:  "47bdfc0889fde6a98731e33be62a70b26d88a54ce472fdd16b20bc7b1d14aaba"
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

    assert_predicate testpath/"test.png", :exist?
  end
end
