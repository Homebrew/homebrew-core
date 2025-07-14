class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.17.tar.gz"
  sha256 "dafd6ee72d36226d4664ca32d85d0b68224d5dba710abb8a4578c427259858e1"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "eda2929f078abdb61a78c62445ca3cf33f6781c154e746eb38b3e3994913c34e"
    sha256 arm64_ventura: "bcfad24eed6c8cc1efbfa8773f1542410288cb1a670a218ef9cda0f715553a7e"
    sha256 sonoma:        "92af020b38817ecc3c2dbc5d386d53e7abe643a8f394db5236caaf44143a34c6"
    sha256 ventura:       "764b7395a66bd11320ea8c7a64d4ca2769bc7ee3aef9fdb67a0e7dc93fef52ca"
    sha256 x86_64_linux:  "f3a17380ee1c81dd4d4f8345c167723ac63dd589007a3987af527f8d48343482"
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
