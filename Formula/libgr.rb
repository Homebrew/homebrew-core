class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.8.tar.gz"
  sha256 "01f235c0f74509a9d6ad8720156835729d386ad2f447cd24dcb536ca384c9ed9"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "6d7c27dcbcc81403256cded975a91d29d241b07c78abd565d6c30b93cddd1f52"
    sha256 arm64_monterey: "b73d96fe27de2ec48d9f233687ab9be87ddbb764ddcfdf7a8e20a522c89256f7"
    sha256 arm64_big_sur:  "06ee38869b268c3e438528e2c6218293708cad3d2b61f9e98504edbd69d81542"
    sha256 ventura:        "49ec0381a261cc144b692f51a5a8b9476eefba288f4bac2ceecea33e5db08f99"
    sha256 monterey:       "888043f38ef309db435b9b4fb0e77d756f0cef7be1f7938f478996c0aebddc1f"
    sha256 big_sur:        "1abcb35700edbe09ed477f923ee63dcf5a2e37c65b66e8cbe77476a1de1210be"
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
