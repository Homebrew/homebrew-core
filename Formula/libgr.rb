class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.72.1.tar.gz"
  sha256 "1d03eda3761e212f150d64236c7bd8e29ae9f46843a7c210e84ec8ca1bb5176f"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "1a9a592020ac7df6b44fddaa7d018d0026f68939be219345b6a11026b8b28407"
    sha256 arm64_monterey: "32d2739caefcdb97c620934685775e73e4b9ec53d7da433f67e5ac21755b5dc7"
    sha256 arm64_big_sur:  "8762a2ea8786bdbbb50c8d5c38a694a237efe11bf9482ef4a4ad09556ec1b108"
    sha256 ventura:        "7b8a7119b04f94fe79231b193d47a3213e8161c7dd300f71d6246a434915e5f9"
    sha256 monterey:       "6524b99bfa153669ee5bd72efb5ce2f1268fc2a3c18f921677219469ba87b01c"
    sha256 big_sur:        "0fcfef7d9411bc6d26a91e9afc55730c48cca9621abf846135baa9de3731c60e"
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
