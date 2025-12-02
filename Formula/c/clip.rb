class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://github.com/asmuth/clip"
  license "Apache-2.0"
  revision 5
  head "https://github.com/asmuth/clip.git", branch: "master"

  stable do
    url "https://github.com/asmuth/clip/archive/refs/tags/v0.7.tar.gz"
    sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"

    # Fix build with fmt 10, the issue is fixed on HEAD because the logic was changed
    patch :DATA
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "db658e6fcb0e356d9c460e6a9d68a284b7cfc259410427072fe0a3e980a79c3b"
    sha256 cellar: :any,                 arm64_sequoia: "39474a5890b2367e6ef4e94946bfd9298d939b124cca416f7c497a9594c767b0"
    sha256 cellar: :any,                 arm64_sonoma:  "23bb3a919a00675c27a554bb7a23452d619cd19cd7cdb8259f73549500cce43d"
    sha256 cellar: :any,                 sonoma:        "abf0e00a25e56c1791a9c02c00ce5aa0daacb4fb905e67710b6542d165a56e3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8681f1d1300b0344c10090065c88c6bd20a3131963d9253084bc9178428c25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11bab1e5129fadb9ee981a3fce1a5d5398e5ca11b7dee3a10dc325b8db8b80bf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fmt"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"
  depends_on "libpng"

  conflicts_with "geomview", because: "both install `clip` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system bin/"clip", "--export", "chart.svg", "test/examples/charts_basic_areachart.clp"
    assert_path_exists testpath/"chart.svg"
  end
end

__END__
diff --git a/src/graphics/export_svg.cc b/src/graphics/export_svg.cc
index 12aa4ef7..2316063b 100644
--- a/src/graphics/export_svg.cc
+++ b/src/graphics/export_svg.cc
@@ -159,7 +159,7 @@ Status svg_add_path(
       case StrokeStyle::DASH: {
         std::string dash_pattern;
         for (const auto& v : stroke_style.dash_pattern) {
-          dash_pattern += fmt::format("{} ", v);
+          dash_pattern += fmt::format("{} ", v.value);
         }

         stroke_opts += svg_attr("stroke-dasharray", dash_pattern);
