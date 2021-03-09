class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.55.0.tar.gz"
  sha256 "070ca1cb0a54f90446e2cc0a0b331a112e0842e32a000bad2135e26ce09f5787"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_big_sur: "248211e7864da1928b0825534e5b6518daeab27949b59a0f8306dc2c3052021a"
    sha256 big_sur:       "c3f7f2047d7bdffbf444e02a7207336d164ad35f84599120859602201e0bc5c6"
    sha256 catalina:      "168c22d7b50eb861cba4f9bd4cbedbefdd9c2583b4845d8ddc8b96b25fb79df6"
    sha256 mojave:        "ae26f4e81badce18f8cf411ef9fc81ac132708ba0a739bd7e8fb3a40b60682ba"
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
