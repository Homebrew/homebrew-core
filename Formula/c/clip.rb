class Clip < Formula
  desc "Create high-quality charts from the command-line"
  homepage "https://github.com/asmuth/clip"
  license "Apache-2.0"
  revision 3
  head "https://github.com/asmuth/clip.git", branch: "master"

  stable do
    url "https://github.com/asmuth/clip/archive/v0.7.tar.gz"
    sha256 "f38f455cf3e9201614ac71d8a871e4ff94a6e4cf461fd5bf81bdf457ba2e6b3e"
    # Fix build with fmt 10, the issue is fixed on HEAD because the logic was changed
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e65b6602f8310fa20b2dbccc53bc4d090736869a8ba71e6038d7cf279b106e98"
    sha256 cellar: :any,                 arm64_ventura:  "7bf42be3c4e801e44703b3c8a962c57d8954d3e485ea543006fe2ea40de6d1f8"
    sha256 cellar: :any,                 arm64_monterey: "19abd42b4275674b6dc23f3bd73ecc964c511f13f5005789ed1245d59a3eb1fe"
    sha256 cellar: :any,                 arm64_big_sur:  "aee203a305119447f0b85edbd3a4402fac8eac9173a0140d61545fce9f5a82ee"
    sha256 cellar: :any,                 sonoma:         "83f111f7b472d1c2464c20eb9fc0d2029482e0679b2d305ff59f5806c2c7ba9f"
    sha256 cellar: :any,                 ventura:        "31cac271bb4e5d72a86455c7761d70619afe06b25269c617ba29a98d4e96eba9"
    sha256 cellar: :any,                 monterey:       "e56a30f599d2a0e117bffba8507bb4ee1f2be06c8b75784875312287138caf00"
    sha256 cellar: :any,                 big_sur:        "89fba65ae4a95e419d4b3838360911954362a97d0d6613734d72c2a1f4b10567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec01ad4f33c27fedc8ee857603096d8495623d2095baf7714a1a95a2665a1fac"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  fails_with gcc: "5" # for C++17

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "#{bin}/clip", "--export", "chart.svg",
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
