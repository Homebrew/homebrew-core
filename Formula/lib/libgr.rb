class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.17.tar.gz"
  sha256 "dafd6ee72d36226d4664ca32d85d0b68224d5dba710abb8a4578c427259858e1"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:  "3ce60c550dcd8720707e307b8ac7899815a941b579bd4f01b960675699ada710"
    sha256 arm64_ventura: "cb3af42272d1ad444e7552f9fda7ec20de5756355d65d140500658c9466c541a"
    sha256 sonoma:        "309cb93ea973b305a0503eae8890d1aa7c74724dbcf3451aceaa7892efacf4ad"
    sha256 ventura:       "24a5a93b585691867de0d39daa4cad50d4bb5a9704a19b871444f187a1102e67"
    sha256 x86_64_linux:  "e2515bd932c6012a30f536435b9a3e1cfb7d4c2523a61720dd2e98978a67fae0"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg@7" # FFmpeg 8 issue: https://github.com/sciapp/gr/issues/197
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
