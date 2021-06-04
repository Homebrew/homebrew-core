class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.57.3.tar.gz"
  sha256 "4ea87656681be64d50d457535a50f5df4c77546da5541702bda1e49c5224acef"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "052158627eded85ba8e4f41cca738b1d7984c7d24bc93a37cc2f7c9a2245d3ba"
    sha256 big_sur:       "5cacdca888cded74fb71aedeb2d092e71bdf471ad3f79488fd841d8813e2ce68"
    sha256 catalina:      "17f11bd59cc72e234c55bbc982da79f2a422bedc2ace5ae84b8b677ee521650a"
    sha256 mojave:        "7cd7e72a0006515aafa717cbcd11661cfcaf48b040b098f3fca31850fe63f800"
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
