class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.72.10.tar.gz"
  sha256 "32c829660d4634f4097fb0a2729719071e201115900a193f608413850314f3ba"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "a4237b240e6d881a65b9a27a92f6475a1bd7d89bd92fcd6dc1c4f127123269b9"
    sha256 arm64_ventura:  "2e1eab780ff547ab0c5b81bd8ff523cc5a6add81e62ed2562f04743f3bfc4139"
    sha256 arm64_monterey: "c84b2e82fbb8b6b0b17336010f1f99fa62ea7c0a46dd8274bf0e56d33da55761"
    sha256 arm64_big_sur:  "1e2e3b15e2f668d43dd8cba51a5614c2856c706bb70bb380504b2173d8ce6acd"
    sha256 sonoma:         "7f7a1fd955ba02341f10e3b19983850fbdb53eafbbbee5f88059d3ee0955bad6"
    sha256 ventura:        "b44eeac18464077c54f95a3fbf579db3fa6dc8084341c4424eb72cb7dc15a58d"
    sha256 monterey:       "5374ae7fec2483fb6db32084d739cd780e982aea380d0024c433ce02ef9a4209"
    sha256 big_sur:        "6ee088103e077df839074c71ebcf102d7f5b99fa807f1cd16693c999f5c349a9"
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
