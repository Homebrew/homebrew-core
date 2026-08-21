class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.26.tar.gz"
  sha256 "6dfe5bbd0c321d0714f391ad2e65b983fc0c34f518df773f7c7fa18545fd0fb5"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "df84bca8c6672788b45ac0fd47d526325642e507481bf572732aefc8d8dc2e9d"
    sha256 arm64_sequoia: "7c99767fd4717119bc3e1ec42ced9d45746c335e05a2e5b7e5562979d0ec91a6"
    sha256 arm64_sonoma:  "54c1bd6545bb169622b4019fdc9f2fa1063018430728a4bab65d1dc9f34a8ecb"
    sha256 sonoma:        "8b2f783b9c422a569bdbb309eafee70565fb16647238bf49a6a4a2b3fcd0ee17"
    sha256 arm64_linux:   "ae7f272f71041b2752b8d36cade1bdaf7890a7b046ae7925f5d4b30f7fa66ef9"
    sha256 x86_64_linux:  "9d10dcbe39053245393e5b5defa607c93d15e373a1333d3a5af38f6fb1ccba87"
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
    system "cmake", "-S", ".", "-B", "build", "-DGR_PREFER_XCODEBUILD=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
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
