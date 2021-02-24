class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.54.0.tar.gz"
  sha256 "82ec7b3d32d0536325ef8751ec87b607c9969005702ebc0cd3ed8c7daa029b94"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "27566548703b9312be86fe77ec4b311f8429c79196e5eb8b053ba482ff126fc4"
    sha256 big_sur:       "698e61f387cfdf26d55e353907c306ffe28a1ff69cb80f11b59310845bd679e0"
    sha256 catalina:      "82065ace7fc52971fea0434f0326a2f9ca0d277989178279d8fa9fc95c7d2357"
    sha256 mojave:        "d6c62e21573629c842c42328321879baa6d6fc10f9a26198b4a29690e29654fc"
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
