class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.26.tar.gz"
  sha256 "6dfe5bbd0c321d0714f391ad2e65b983fc0c34f518df773f7c7fa18545fd0fb5"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "07b476006d6586ec2ed7894d8164a51c5e825bd637437cf9bf47ee38a727e445"
    sha256 arm64_sequoia: "f61b6cfb59fa3b3a8b6d4d867eaf4a097264276434412d1ced44b17330f97f1b"
    sha256 arm64_sonoma:  "30425591dc9e79ad6b2c392e72aed74940f7f6f9de99fea86654e75a67f7d860"
    sha256 sonoma:        "6931ebb56ae025f69a26769b2c97396e8f4d655bd3cf15c240f0f652cb117a71"
    sha256 arm64_linux:   "d2a0cec1fb6405ebafd88d26cf93b63dc855a33e1c6500d97d9e1f3dcd511bbe"
    sha256 x86_64_linux:  "afd5fc8b8e06a4407cf167ae23ac5901d899aa132ddf55bc3029ea15cd3861ec"
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

  on_linux do
    depends_on "libx11"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DGR_PREFER_XCODEBUILD=OFF", *std_cmake_args
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
