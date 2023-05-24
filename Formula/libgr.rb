class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.72.6.tar.gz"
  sha256 "ae87f17293b3ec467475bca1c7edb3864a249a0123e10a499e888cee14517f02"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "02662cbdb04c10083b74aae7ae054d5ed6d883265754cd2a51c41aaae5ebc5a8"
    sha256 arm64_monterey: "8d7e3acc13807a20a18382ef44df4c10487c0527e40c8946926bf0a762ac95a6"
    sha256 arm64_big_sur:  "10f59ceb80bdc3c42711aa1e5f52f961707c7fe309604429d8704eac324b0698"
    sha256 ventura:        "75ec708f5b37d2d7f52ec129eac62ac35e127768bfd274c22c54f4e617aba7db"
    sha256 monterey:       "051977fdfb6a321838fc90133ca55252abb8156d19bf08eb11f3072f96785043"
    sha256 big_sur:        "e7aa27358fbe2fb4fc9be4da84e91ae78d1b857cd8c316285bca8ac39800799d"
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
