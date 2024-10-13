class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.10.tar.gz"
  sha256 "61850f323e201ab6a1abbfb0e4a8b3ba1c4cedbf55e0a5716bdea1df8ae1813a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "46c7b82e649ec870d6d3cc2c0afa10e6440415a106c7125b5e32c4f0fddd9ce1"
    sha256 cellar: :any,                 arm64_sonoma:   "e81fa40995450b6f13fb3675bac57aeca83380faa146bed41304de45e3938bda"
    sha256 cellar: :any,                 arm64_ventura:  "fd260454a7b9caca630278659b1e7398a63d36ee2abfacaabf0bf5c15d032915"
    sha256 cellar: :any,                 arm64_monterey: "0741dc2a9c7f9228764e05de9bcb407ef3c063ac0a224b2732f40bf4b4631c99"
    sha256 cellar: :any,                 sonoma:         "7cd8b4df89b8563f087459d460cb93845bc897376a520fe4efe0c4ad2fd9bb43"
    sha256 cellar: :any,                 ventura:        "76d2391ad2721e30a94002a04a7bb66bebff4ecdf2319e0083fffbc06749cb7d"
    sha256 cellar: :any,                 monterey:       "6fee96fd5d7bbe0a860fa4ac80c7548af1785a18746eef4636e8ea1a1156c7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d67735677d48bb53f47c636ba0a34c3440235ca394d68767e88caeb709ed99c"
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
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "mpfr"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

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
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
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
