class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.14.tar.gz"
  sha256 "44812cb33ce6a3d3c58415a03cc1faa881abfb9a84d3623be054843248c98d3a"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "b6a0df6b910b3e78ce870e8197b45860685210f92b2dbd9895504a6a2ae1e54c"
    sha256 arm64_ventura: "44da0c44166abe526e77f763e4aa3243b729a43ecbe86bde2858ff5f60d09234"
    sha256 sonoma:        "134f17558c927ed967a1d8055ba5fbc9691e8720fe845b91c46ed9afa0ced74a"
    sha256 ventura:       "8569d42c0249b9280275624ca38f9ebc852ca72b5fd638977a4f04849d1ca5b9"
    sha256 x86_64_linux:  "f645563ef34f03ec5f59370c8a447fe32059efaf9df20ebdb2fc4c7ea56b7a36"
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
