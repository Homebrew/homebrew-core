class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.20.tar.gz"
  sha256 "d26c2051f483eab1c2eeefc8ec28eaa1fb06d43957848a8af6fe18c550638d29"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "037a45c213da0f7857f7b1155dd862a2398d3c8501a2015e6cb79b54118606c6"
    sha256 arm64_sequoia: "70833a4769a6e2932ca800fb86e2ef9229fc15324c9ecac75aa6876f744861bc"
    sha256 arm64_sonoma:  "e88009daffd7fc9557db54f4c6cb64cad9a314d6f903d799adfe2eccd7440210"
    sha256 sonoma:        "24a8cb35bd0c3a93ec653d030d8b53c432c5305b45123715addc9c0653c4d9d6"
    sha256 arm64_linux:   "bc8e7a1e4d34f8af2240fcba5987c70c80ffee5774404ee523f1ca2fae1acd4d"
    sha256 x86_64_linux:  "4c43b8af9fc11de8da0efd3a4539228a8b3f26a85b12b78ef7137b96043d29a3"
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
