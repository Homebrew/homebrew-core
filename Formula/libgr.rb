class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.66.1.tar.gz"
  sha256 "d718d4b8d6644b4b88ebe5b5b9875f3a097cd283654769e50505016e673765b2"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "09e69f3b2bb39e81a4af038dfa57e1bf22ef9cbdf0acfb65b9ff2e2b35ebe6fc"
    sha256 arm64_big_sur:  "4e88e55474447ea32cebdd843db7351e6ee61067fc32464ed95330099eee8585"
    sha256 monterey:       "16dd395c793f5ef4330ba4f4d13976739c700331990f852946f1ef93c9ea90f1"
    sha256 big_sur:        "db3abd179d84be413af69ca7bd762e881fcdd81802d126244ecdb245186411bf"
    sha256 catalina:       "8654fd9cb4aa29498e782985f43b266488b4fb896fc4c72146f76b1862ba0863"
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
