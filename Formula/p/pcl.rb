class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "https://pointclouds.org/"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/PointCloudLibrary/pcl.git", branch: "master"

  stable do
    url "https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.14.0.tar.gz"
    sha256 "de297b929eafcb93747f12f98a196efddf3d55e4edf1b6729018b436d5be594d"

    # Backport missing <functional> header. Remove in the next release.
    patch do
      url "https://github.com/PointCloudLibrary/pcl/commit/61b2e8e5336d7d8b0e1ae7c1168035faa083310b.patch?full_index=1"
      sha256 "06e17f22d497a68b0ff3ac66eb6ba3d6247c9b9f86ae898bc76abcdcb5a2d5ba"
    end

    # Backport compatibility with Boost 1.85.0. Remove in the next release.
    # Ref: https://github.com/PointCloudLibrary/pcl/commit/7234ee75fce64bd15376c696d46a70594fc826f2
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0772149d0bce174cd6894d2561e2e5be2e4684e734b1320e300e5295d9431edc"
    sha256 cellar: :any,                 arm64_ventura:  "79bd1dc809f782085e7af19629769610f00da56636e0ff2c5316f3096a6b3b94"
    sha256 cellar: :any,                 arm64_monterey: "f5bbf0098d842a8ee7363abef4a3569d0098d0f4818c136c54e3cb3504a27f91"
    sha256 cellar: :any,                 sonoma:         "07d5a586df25d368483f2c3b9edf8abf182dcef3b434788b9abdde6f783e6394"
    sha256 cellar: :any,                 ventura:        "afa14e78c20ccd099134248fca59768fbcd0735a586d767d7beb38ca6089da70"
    sha256 cellar: :any,                 monterey:       "7b215314d0b6bd24df61a552d976e34aef88b8b4eb8b19b56127af68eca10e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "694f8f92d0c3758119e4ae47c09a42af43e5b0cf4cf77bd12fc943b4f389cd9b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  depends_on "cminpack"
  depends_on "eigen"
  depends_on "flann"
  depends_on "glew"
  depends_on "libpcap"
  depends_on "libusb"
  depends_on "qhull"
  depends_on "qt"
  depends_on "vtk"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %w[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_apps=AUTO_OFF
      -DBUILD_apps_3d_rec_framework=AUTO_OFF
      -DBUILD_apps_cloud_composer=AUTO_OFF
      -DBUILD_apps_in_hand_scanner=AUTO_OFF
      -DBUILD_apps_point_cloud_editor=AUTO_OFF
      -DBUILD_examples:BOOL=OFF
      -DBUILD_global_tests:BOOL=OFF
      -DBUILD_outofcore:BOOL=AUTO_OFF
      -DBUILD_people:BOOL=AUTO_OFF
      -DBUILD_simulation:BOOL=ON
      -DWITH_CUDA:BOOL=OFF
      -DWITH_DOCS:BOOL=OFF
      -DWITH_TUTORIALS:BOOL=OFF
      -DBoost_USE_DEBUG_RUNTIME:BOOL=OFF
    ]

    args << if build.head?
      "-DBUILD_apps_modeler=AUTO_OFF"
    else
      "-DBUILD_apps_modeler:BOOL=OFF"
    end

    # The AppleClang versions shipped on current MacOS versions do not support the -march=native flag on arm
    args << "-DPCL_ENABLE_MARCHNATIVE:BOOL=OFF" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install bin.glob("*.app")
  end

  test do
    assert_match "tiff files", shell_output("#{bin}/pcl_tiff2pcd -h", 255)
    # inspired by https://pointclouds.org/documentation/tutorials/writing_pcd.html
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
      project(pcd_write)
      find_package(PCL 1.2 REQUIRED)
      include_directories(${PCL_INCLUDE_DIRS})
      link_directories(${PCL_LIBRARY_DIRS})
      add_definitions(${PCL_DEFINITIONS})
      add_executable (pcd_write pcd_write.cpp)
      target_link_libraries (pcd_write ${PCL_LIBRARIES})
    EOS
    (testpath/"pcd_write.cpp").write <<~EOS
      #include <iostream>
      #include <pcl/io/pcd_io.h>
      #include <pcl/point_types.h>

      int main (int argc, char** argv)
      {
        pcl::PointCloud<pcl::PointXYZ> cloud;

        // Fill in the cloud data
        cloud.width    = 2;
        cloud.height   = 1;
        cloud.is_dense = false;
        cloud.points.resize (cloud.width * cloud.height);
        int i = 1;
        for (auto& point: cloud)
        {
          point.x = i++;
          point.y = i++;
          point.z = i++;
        }

        pcl::io::savePCDFileASCII ("test_pcd.pcd", cloud);
        return (0);
      }
    EOS
    mkdir "build" do
      # the following line is needed to workaround a bug in test-bot
      # (Homebrew/homebrew-test-bot#544) when bumping the boost
      # revision without bumping this formula's revision as well
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["eigen"].opt_share/"pkgconfig"
      ENV.delete "CPATH" # `error: no member named 'signbit' in the global namespace`
      args = std_cmake_args + ["-DQt5_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5"]
      args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?
      system "cmake", "..", *args
      system "make"
      system "./pcd_write"
      assert_predicate (testpath/"build/test_pcd.pcd"), :exist?
      output = File.read("test_pcd.pcd")
      assert_match "POINTS 2", output
      assert_match "1 2 3", output
      assert_match "4 5 6", output
    end
  end
end

__END__
diff --git a/outofcore/include/pcl/outofcore/octree_base.h b/outofcore/include/pcl/outofcore/octree_base.h
index 45959b95236fd510981c6f61a14d0eae6f4c7685..1a7c8778c1046921af3ae6d5ef8bb5e45e9feb1a 100644
--- a/outofcore/include/pcl/outofcore/octree_base.h
+++ b/outofcore/include/pcl/outofcore/octree_base.h
@@ -63,6 +63,7 @@
 #include <pcl/PCLPointCloud2.h>

 #include <shared_mutex>
+#include <list>

 namespace pcl
 {
diff --git a/outofcore/include/pcl/outofcore/octree_base_node.h b/outofcore/include/pcl/outofcore/octree_base_node.h
index 7085d530227da76bb441a73ee13508bf60c2d720..dba76d4f04ff2b7536525ae56d2699f479cf8d6f 100644
--- a/outofcore/include/pcl/outofcore/octree_base_node.h
+++ b/outofcore/include/pcl/outofcore/octree_base_node.h
@@ -42,6 +42,7 @@
 #include <memory>
 #include <mutex>
 #include <random>
+#include <list>

 #include <pcl/common/io.h>
 #include <pcl/PCLPointCloud2.h>
diff --git a/recognition/include/pcl/recognition/face_detection/face_detector_data_provider.h b/recognition/include/pcl/recognition/face_detection/face_detector_data_provider.h
index 7b4a929df52604a269fde377850ac55930074faa..be3b86aecc1cc2a78cf787dd86e8d6f3b3ca0449 100644
--- a/recognition/include/pcl/recognition/face_detection/face_detector_data_provider.h
+++ b/recognition/include/pcl/recognition/face_detection/face_detector_data_provider.h
@@ -12,7 +12,7 @@
 #include <pcl/recognition/face_detection/face_common.h>

 #include <boost/algorithm/string.hpp>
-#include <boost/filesystem/operations.hpp>
+#include <boost/filesystem.hpp>

 #include <fstream>
 #include <string>
diff --git a/test/outofcore/test_outofcore.cpp b/test/outofcore/test_outofcore.cpp
index cb5cfff4aca489bf029e8713f175635bad8d1071..3f658bf86ea14591d3dfbd4494f79c8c4ef2ea80 100644
--- a/test/outofcore/test_outofcore.cpp
+++ b/test/outofcore/test_outofcore.cpp
@@ -44,6 +44,7 @@

 #include <pcl/test/gtest.h>

+#include <list>
 #include <vector>
 #include <iostream>
 #include <random>
