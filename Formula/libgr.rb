class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.61.0.tar.gz"
  sha256 "fcacfcb42081159539f90d29f882d45b84802f4fe8fcad5a135c413fe7ece27d"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "bbe22862665f7d8cc36b979270baedc0059213ca8b6ff64104a9fe2ae89fba46"
    sha256 big_sur:       "b0bb1567c1ea767224b9bba385aee27fbd0d6961be19748972cb57070d5cd99a"
    sha256 catalina:      "8cdb53f04c119c56e3c0062ad0d9b4a54a520e838741cac56ab90b1293ec255d"
    sha256 mojave:        "60eafaaa998bbf2805a79e3ef02eac6e552367a05be5671a6e102e6de54f560b"
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
