class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "https://pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.13.1.tar.gz"
  sha256 "8ab98a9db371d822de0859084a375a74bdc7f31c96d674147710cf4101b79621"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/PointCloudLibrary/pcl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bf35b3f05a12a11fbbe48ae51f8cf168b566cb7d62b22615a3c40edca07a9069"
    sha256 cellar: :any,                 arm64_ventura:  "c2bdc69964fd9a4db03282f88ddb38b70606c75dcb94ed113b5ca39d171bca87"
    sha256 cellar: :any,                 arm64_monterey: "d09bb9c4d5041bb4d695f566c77d437513f62d6ceaf1031c32019f72cf096839"
    sha256 cellar: :any,                 arm64_big_sur:  "760edc5eaa8270b0fcb62435723361a3c915b33a070736ed897caa0a7a7c2592"
    sha256 cellar: :any,                 sonoma:         "3a47bc4653c569f9c6066267b1f5025bfc2fb615a5b89feb83d2826c2093b5bb"
    sha256 cellar: :any,                 ventura:        "7fc94ebb02820db5afd4b8c4ea0f0f4add189f7e7b174d85a9a26e9483c09e0e"
    sha256 cellar: :any,                 monterey:       "0d95ebde14a90d394e65370a79647dac7b3874e3fc7a0b2c1bd6e74757ad6ed5"
    sha256 cellar: :any,                 big_sur:        "2ce70da8eefae1457fc3c0f7f5d77d3c65582c4a86737aa6b371275f5394e433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ad577cfc09f3bb2f37fe1b59850cb18869fddfc0c24ae6576ebbbcde0b989f5"
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

  # Fix build with Qt 6
  # https://github.com/PointCloudLibrary/pcl/issues/5776
  patch :DATA

  def install
    args = std_cmake_args + %w[
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install Dir["#{bin}/*.app"]
    end
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
diff -pur a/apps/cloud_composer/include/pcl/apps/cloud_composer/signal_multiplexer.h b/apps/cloud_composer/include/pcl/apps/cloud_composer/signal_multiplexer.h
--- a/apps/cloud_composer/include/pcl/apps/cloud_composer/signal_multiplexer.h	2023-05-10 08:44:47
+++ b/apps/cloud_composer/include/pcl/apps/cloud_composer/signal_multiplexer.h	2023-07-31 18:04:25
@@ -42,6 +42,8 @@
 
 #pragma once
 
+#include <QList>
+#include <QObject>
 #include <QPointer>
 
 namespace pcl
