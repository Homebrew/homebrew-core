class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.53.0.tar.gz"
  sha256 "a348602c3e2d928b5c293a19ed91e126bf56e23720d4f0e12aa92767da767276"
  license "MIT"
  revision 1

  bottle do
    sha256 "a62524317ad69b3e60c8e30639b712c63cfb21c190045c3e81a96964aedaa7af" => :big_sur
    sha256 "a2b5205e39dab110bffed5b0d2ba65c406357cae506f104cc5d5ac4ffc3d03f2" => :catalina
    sha256 "2ce2a02ab4e593bf7f67fec74d76e15456f1261dd74d6abffe18d91fa26dc9be" => :mojave
    sha256 "b90abf73dbd6f77e4c8c98c7887ca0ce32bb085a11542f1e942dd6495a641d3e" => :high_sierra
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
