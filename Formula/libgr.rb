class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.66.1.tar.gz"
  sha256 "d718d4b8d6644b4b88ebe5b5b9875f3a097cd283654769e50505016e673765b2"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "f47326318bed664b81a2e0a5ab425316e3df3636be8502680b846f9fbc245764"
    sha256 arm64_big_sur:  "6d9b4336c270f0d520d9c7327c06c602659ebbaca333c1675175500e5723bd6b"
    sha256 monterey:       "aabb22b5d0cb4dad94c2196166ca8343abb10df45f72829178ff06db9d2e0300"
    sha256 big_sur:        "fa2fdfcb99e52c10fe14ef4669dd2a2ae7e5b6092f6b4b4b9f9dfba2bcf7a520"
    sha256 catalina:       "ca89bf93df1d79bedd2bbf9f02f3c99247f9068a16d735a6a2c6fd67d843a218"
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
