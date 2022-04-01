class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.64.2.tar.gz"
  sha256 "6562dfa65c57fa626957475b70c2cb659da17f4fdb02bdd25be4c33e84f881c6"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "08acdfad4b6f20b9dab47a5c9b369df887f6b5bc79f0fc769b5e6b0644a77e1c"
    sha256 arm64_big_sur:  "30bdcdba4f5dfb30c9b645733d317398728c0a2d6c80bbe69be3c2e8a3b5eb89"
    sha256 monterey:       "cc130ac34b04ce565da67fb943ef0874e7f5245ba9945fca1a189bc19ec6fe77"
    sha256 big_sur:        "fe96648ff60a80023cf7f94b3f2d7d02f63c8e15ebe97eab93eca909fb74110f"
    sha256 catalina:       "77ed1c9a5ec599d46a8d8a5a3e0246777a7c8b73cef28f9a5c798c8d886662ea"
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
