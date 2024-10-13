class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://github.com/asmuth/clip"
  license "Apache-2.0"
  revision 4
  head "https://github.com/asmuth/clip.git", branch: "master"

  stable do
    url "https://github.com/asmuth/clip/archive/refs/tags/v0.7.tar.gz"
    sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"

    # Fix build with fmt 10, the issue is fixed on HEAD because the logic was changed
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4e2ca7b930f87658ba6450ad93a84b92b8d22c807f23eb8161c6c0cf3bd4fe88"
    sha256 cellar: :any,                 arm64_sonoma:   "3113e6da1b2952a1fb192798702a682bb4a1b15528deef855728cb7747e73a6e"
    sha256 cellar: :any,                 arm64_ventura:  "35c0b71a4027266682fc887c730d90da8ed7a70376e676f083ccb77080aa487a"
    sha256 cellar: :any,                 arm64_monterey: "1eac839633823737b47b9908706b6e4fc71d868db0317505b5ced38c3bc18004"
    sha256 cellar: :any,                 sonoma:         "704a966e9cde6a3d7ec3fb7f89001951ec21c6c17ea19c949d40525b5ee99993"
    sha256 cellar: :any,                 ventura:        "b9d9581c495fd0de481bdd29e90c83a2d754728bae91cbce79d33b203f49f234"
    sha256 cellar: :any,                 monterey:       "1727420363dd11f068d983246bc72c1984989a317d7469a559aca8362aa2b546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ec83f22a9c5a10603172933fb1de5ae5f261e30891e0ecf4b800094eab60ce8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "fmt"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"
  depends_on "libpng"

  conflicts_with "geomview", because: "both install `clip` binaries"

  fails_with gcc: "5" # for C++17

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system bin/"clip", "--export", "chart.svg",
           "test/examples/charts_basic_areachart.clp"
    assert_predicate testpath/"chart.svg", :exist?
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
