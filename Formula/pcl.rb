class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "https://pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.13.1.tar.gz"
  sha256 "8ab98a9db371d822de0859084a375a74bdc7f31c96d674147710cf4101b79621"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/PointCloudLibrary/pcl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "71a62c5aa5e77cd4062236dc35f76564d0d35146f497399d4eae193b15bf8242"
    sha256 cellar: :any,                 arm64_monterey: "35811a631c26581fe21c90008a1900acb18d15c38b7ae51654c3cfec8fa68814"
    sha256 cellar: :any,                 arm64_big_sur:  "35c965b47d1300821e8c03a6415bb6b22dd6e74fa9e2cff5a115c88a47d7a9bc"
    sha256 cellar: :any,                 ventura:        "ba92059c02bac98cbe70b456e4c5c42aecd76d7f4c81b22fe0c7cec06ac46fdf"
    sha256 cellar: :any,                 monterey:       "7a43badf45d2c42917d39229cb0c97514896d35c2d7a69f7bf6cef57aaa36dd6"
    sha256 cellar: :any,                 big_sur:        "6e2ed8d191b3b809bfd87f69f37eea5661d69f441675926e4f3d0d608bc5fc7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80803970008cc951b3d50c013b6cd600becc304fca13532a603dae4cef22976"
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
  depends_on "qt@5"
  depends_on "vtk"

  on_macos do
    depends_on "libomp"
  end

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
