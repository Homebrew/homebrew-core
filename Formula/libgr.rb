class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.7.tar.gz"
  sha256 "781bd832e55939daa7362f86476b67eaa4158beacfdeadb8c4d41be0dab10c54"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "e45746d2242c3b554d3f8f2d4453d343789b27823a3f53429f988046c31adac1"
    sha256 arm64_monterey: "a55edaeb62b9a0d529b7f6ec09dcee4c43c89243b2de005d9d81af35c200f287"
    sha256 arm64_big_sur:  "62761d814d39a67db78a53df90699d83cf5dc4b5624c64ac6ee004e76d1169a5"
    sha256 ventura:        "0f331a09aad811d806529de5fb3c23d456efee358aa06266c45bcd07649982cd"
    sha256 monterey:       "21101455e19d8e1f6bbb4265a0291e6e89025f54852f15274c6a7e775f455509"
    sha256 big_sur:        "e763dbeec59536912585215d32332fca60e9fa72289691756e8ab5637bc12248"
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
