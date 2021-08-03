class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "6bf66fb3f5cb55ccae2f9577b6c6f82443d9cb1e29e9992371a0beae15dfbc0d"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "d3d082aee36650ea283fe1ea4969abe4b1ae2f8db848f4bac7576ed8cd9c17c0"
    sha256 big_sur:       "9da9f02d00b6f13b05c118b8e174310bacdbc757545dc67998683eb36be6562e"
    sha256 catalina:      "fad3eaa6b8bfc7d467affa00cd8c4d8c6fc5de7183e8b1224d605d5a6e32adcc"
    sha256 mojave:        "77302ad762bd55b278b5fd36f66e840a6b50075c995999583a5a1bf13febd119"
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
