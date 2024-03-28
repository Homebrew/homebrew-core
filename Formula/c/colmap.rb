class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.9.1.tar.gz"
  sha256 "f947ad80802baa8f00f30f26d316d8c608ab2626465eac1c81cf325d57879862"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b11c849fb78608b093923e4cd4fb8e787bfbe20b8fddf9f870213b5eed2c50fc"
    sha256 cellar: :any,                 arm64_ventura:  "fec342de2d5ae076d042d57753ce05579706ed772ce88194348e7f8ba9f57f48"
    sha256 cellar: :any,                 arm64_monterey: "92df62d9a0143d60723f23beb558a3ff981f23778c1e637bd483105bb94e4b30"
    sha256 cellar: :any,                 sonoma:         "02ef38d93ab07042a1e1154ce6d35cb196619698b1e5cccdf5d6b54011862872"
    sha256 cellar: :any,                 ventura:        "535fc9fe53fe4d12460918ef578bd95eca30bee47125fd5944fe984ac527e20f"
    sha256 cellar: :any,                 monterey:       "eba5f8d2fdcd8fe2ba612535efcad03ab470052eb8e451de280c1063b5ebbdb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718f3c2d799beed5863dad62393691f5f04f1a71432c6e0682788102cd125383"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "flann"
  depends_on "freeimage"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "lz4"
  depends_on "metis"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  # Remove this patch after https://github.com/colmap/colmap/pull/2338 is included in
  # a future release
  patch :DATA

  def install
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    system "cmake", "-S", ".", "-B", "build", "-DCUDA_ENABLED=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end
__END__
diff --git a/src/colmap/image/line.cc b/src/colmap/image/line.cc
index 3637c3dc..33fff7da 100644
--- a/src/colmap/image/line.cc
+++ b/src/colmap/image/line.cc
@@ -27,6 +27,8 @@
 // ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 // POSSIBILITY OF SUCH DAMAGE.
 
+#include <memory>
+
 #include "colmap/image/line.h"
 
 #include "colmap/util/logging.h"
diff --git a/src/colmap/mvs/workspace.h b/src/colmap/mvs/workspace.h
index 73d21b78..6d2c862c 100644
--- a/src/colmap/mvs/workspace.h
+++ b/src/colmap/mvs/workspace.h
@@ -29,6 +29,8 @@
 
 #pragma once
 
+#include <memory>
+
 #include "colmap/mvs/consistency_graph.h"
 #include "colmap/mvs/depth_map.h"
 #include "colmap/mvs/model.h"
