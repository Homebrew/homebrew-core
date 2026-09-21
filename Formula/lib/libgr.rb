class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.27.tar.gz"
  sha256 "970cec765c4ef655b428d8af563edfadf21b733aa0530cf7e90ed18b913ee7b0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "97470c73731b8146e302578111249e07281c10b1d364c84ca25d1b22ad064f68"
    sha256 arm64_tahoe:       "2ca280b0b4e763eb659d22585a55b903c796fe2171e8cec2b5220b1adf9c820e"
    sha256 arm64_sequoia:     "c5b621c207017e2d3537fab8618005bc7fe9500e99defe7531310d8012479c62"
    sha256 arm64_linux:       "33541e81f803c1c0e72a88b79d7daa74804034eb14c114457d46f89a925c3d74"
    sha256 x86_64_linux:      "230c61d1d0950541adac591a4471867a151b1724ec12ae9f9d54e202ded03963"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"
  depends_on "qhull"
  depends_on "qtbase"
  depends_on "zeromq"

  on_linux do
    depends_on "libx11"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    # FIXME: macOS 27 SDK's `XPC_INLINE` uses `inline`, which the plugin's strict C90 rejects
    inreplace "CMakeLists.txt", "quartzplugin\n    PROPERTIES C_STANDARD 90",
                                "quartzplugin\n    PROPERTIES C_STANDARD 99"

    system "cmake", "-S", ".", "-B", "build", "-DGR_PREFER_XCODEBUILD=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_path_exists testpath/"test.png"
  end
end
