class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.3.tar.gz"
  sha256 "4c959abb90535c61ce79c9583b0317dbada5babb46c17d77414c8bd9d42ad8b4"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "386825053225c0294a40da425e7cc56ba422c2b540e8e5be37a03f9cd24c12d8"
    sha256 arm64_ventura:  "124fffe909810a812ffed5f2c0132efa7ee22968f52ef5517996e3720ca7d988"
    sha256 arm64_monterey: "964282a4c7e7caeb6aa52df72fc1833533a3170fcc27fa84b59bcbe842767a46"
    sha256 sonoma:         "4f72baa98339ba394b39e112666e7ef2212a430768e6ed4d47160fd45316d229"
    sha256 ventura:        "4504e9081bf10f5f5eed1c672ccf6611903d3a42bb4677172676c4d4c7c98a9e"
    sha256 monterey:       "e76635b08781bc47b2798961aff2adccfa2551a2dfaae2d2e648eee47088aab9"
    sha256 x86_64_linux:   "5a2ef32aa123c8dc1470446a8a34e117ac7c7685a182f8f4d44dc7619cbf1d83"
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
