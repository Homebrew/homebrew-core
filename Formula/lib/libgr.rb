class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.7.tar.gz"
  sha256 "2584727b1413a337ef14daae1e61bdc5c946403031695b42ecfbf8bc1888d132"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "fec336ec1dbb1c3566ce08deee9d7fd7e6b7549132ed2e22d900bf9dbef0c9ce"
    sha256 arm64_ventura:  "becdedea5be352b8081b27dd59364024963840be9f61f09a2c78bcd355b7b27a"
    sha256 arm64_monterey: "9815c78d0a03182f7e56b00ec740381394c5f83b0960a9bb8539de046215d93c"
    sha256 sonoma:         "587f96c372ad04a8d92a541732fc0188abbcc54ddc0ca12435a8e842d9098d08"
    sha256 ventura:        "bc3a26e21702baa178c3a6e02ba3aca677a57e339aca72ef5750dcb4f50d2769"
    sha256 monterey:       "fc960efd05a90df2e5a8d05f78de301274ae66774da3ef04c97be5e7149eca43"
    sha256 x86_64_linux:   "7a26ce524943d35575a9750c014937c626f00bc84d79ee4febb3672cc2d8f065"
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
