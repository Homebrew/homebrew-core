class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.52.0.tar.gz"
  sha256 "8c9149377bfd3fe61b05cda34b980f894f1a723d7c74c4ace5da2e31d3630870"
  license "MIT"

  bottle do
    rebuild 1
    sha256 "9b7eb3abeae9b64dac36329d4325866576fb09b28e760089d64d6595ea7fa72b" => :catalina
    sha256 "a5b504cab27e88aeca659b71ae5ae39aa43233d933ff835f5945021520389f15" => :mojave
    sha256 "62ae4315df2b121f75a666d6dd3a45736e84d46c8e45f9fd8603385fe1bb9316" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build"
    cd "build" do
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
