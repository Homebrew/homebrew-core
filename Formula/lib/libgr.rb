class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.11.tar.gz"
  sha256 "677bb83e79076e870e8b4df9e5058477ff5b5785ca6197607c09cde659e8dc02"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "99201502644c546449fdc19a41de28560a98f2247dc58a2e3fdd054a232abea2"
    sha256 arm64_ventura: "c33417492a4c673b9a51649f0fe2e66e5ee1a85911cf3b6e97778656a6eadf78"
    sha256 sonoma:        "915e0ed9541a4dd45ba5a40864da64287f5cc0e5fc8153045e1993628018d00b"
    sha256 ventura:       "8f6e15f6fe5b3407e1071174dc7cb6e23cdeb47eebf1b00ace20094c17e74f06"
    sha256 x86_64_linux:  "7279d1599020dcaf1e395c1ec0973dc471e4c67ecf017aa0e9ee3b3d49a051a7"
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
