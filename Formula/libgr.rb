class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "72f80135db4fdf3750ff9d4c9e956de08619812fa5a4c2cb8b00b17a06040dfc"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "f44d488fcc257115ba66ca91bb3fd79d1297249f0a3d0b2200bb4c72dd2d7074"
    sha256 arm64_monterey: "582fca19d085b69ebfdf50a7d47348edf30c3ac20fae07de1a906d58d52bf165"
    sha256 arm64_big_sur:  "db503cb65e0e9384fb16323b10049eb73c995547d218eaacec84ed55451bca5c"
    sha256 ventura:        "1e7e293acebe7ad0ba111bd026e19297b352f14d4f649b0174bccc4ba7151292"
    sha256 monterey:       "f250eee36c1b527197edde8c4ba788a2a0835de9153edcd65e72da830f059c6a"
    sha256 big_sur:        "2667456e668723369f4cb10bbc3c22d63b4bfc7328849aaadaa7b429d5b2dcb5"
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
