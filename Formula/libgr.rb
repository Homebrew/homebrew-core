class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.64.2.tar.gz"
  sha256 "6562dfa65c57fa626957475b70c2cb659da17f4fdb02bdd25be4c33e84f881c6"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "0c966211b4cf1fab8eeb10f74c69fa3dec7fec33bb41158463bf4f637b12749f"
    sha256 arm64_big_sur:  "e8ca0dc9274ab39f353f5150f07798bdd891d6df04058da8e85c9672f72e2665"
    sha256 monterey:       "5d1bf9bbb7fab577ba8e96d96d0ef867cb3e2f3f780c248862b1cc9d52bb46c3"
    sha256 big_sur:        "a0bdcc690f6db4e90a94dbe7186191fc930180801d534252b7d9a562dc1a9d5d"
    sha256 catalina:       "16086d6caf4c1aa6fe0fe882e129273627a8720f0211183c30514edce85f0710"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt@5"
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
