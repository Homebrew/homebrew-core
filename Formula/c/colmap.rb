class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://github.com/colmap/colmap/archive/refs/tags/3.9.1.tar.gz"
  sha256 "f947ad80802baa8f00f30f26d316d8c608ab2626465eac1c81cf325d57879862"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9d00fc57d1f732a4fefb741ab48e221f480e2cb16deeb9ca8f513b6a21ae6e73"
    sha256 cellar: :any,                 arm64_ventura:  "04d186231e777dcbccb8516dd4ffbee31c686698520df771100a330862b48949"
    sha256 cellar: :any,                 arm64_monterey: "e775d2ea1698071def8cfff84feb8514c41bf2415821bce4aec28cf620226cef"
    sha256 cellar: :any,                 sonoma:         "a1d0c5faccff52fd59c3e6e36be5f333f6b77f01026afaf222533260cb600cb5"
    sha256 cellar: :any,                 ventura:        "07548fd18349a37b3b0805fa5ea2f26d3b377729ad89633741838a8b2ef7ea24"
    sha256 cellar: :any,                 monterey:       "bb805ef9f6ae9d67f50a159a914bda94a60f2c5db4b3d28b2063648840c9405f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c7879a56073964c8f8c04247391bc6fc50dc0db4e7f5685c9fa54096092423"
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
