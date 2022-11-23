class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.0.tar.gz"
  sha256 "308885b560d2ee70f8c43e8bb2b38ac4be5f2d6233cbd304193bd0648a661537"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "de2fe0505f6a64591acd0b712d8b826ecd338d732f1ed2dc9ba373e3ba25dd16"
    sha256 arm64_monterey: "5a9a7072be3bbf0b5edb3072ee7dfce78880e79ded1d9cf4c6ae73f5e6b32f9c"
    sha256 arm64_big_sur:  "d7d9b2224199ec66e1b4fc1fd35b089fa8b4f6e59bd65d0c50ad923c52faf469"
    sha256 monterey:       "5e3c866e0ef531b2b0fdf5b23b94e1b1e931c26f3d0ac7d498974a7b23f0dac7"
    sha256 big_sur:        "e4a2c607e72d9ed6c2bbb8312f3d75036bf21e56f94d1a32c038414089a71357"
    sha256 catalina:       "182ae8cd1395e22718d9c2ca964eb666b1bfe914d734cdeee1c498677f3ca8fd"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
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
