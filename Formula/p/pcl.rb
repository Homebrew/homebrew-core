class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "https://pointclouds.org/"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/PointCloudLibrary/pcl.git", branch: "master"

  stable do
    url "https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.14.1.tar.gz"
    sha256 "5dc5e09509644f703de9a3fb76d99ab2cc67ef53eaf5637db2c6c8b933b28af6"

    # Backport fix for Boost 1.86.0
    patch do
      url "https://github.com/PointCloudLibrary/pcl/commit/c6bbf02a084a39a02d9e2fc318a59fe2f1ff55c1.patch?full_index=1"
      sha256 "e3af29b8b70ef9697d430a1af969c8501fe597d2cc02025e5f9254a0d6d715cd"
    end

    # Backport fix for Boost 1.87.0
    patch do
      url "https://github.com/PointCloudLibrary/pcl/commit/6f64495840c4e5674d542ccf20df96ed12665687.patch?full_index=1"
      sha256 "8500e79e1e5c8c636bfc72e5f019e9681f45cd5441954b55bbad4fa48999a6e0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "37abc7e6feb7a024c805fdba2457087848b90a88699d768da84818a46c33c855"
    sha256 cellar: :any,                 arm64_ventura: "313e824687c4a2a315c4f6fcf8e85821cdff51660f0ba6e7b0cb44543e43ec37"
    sha256 cellar: :any,                 sonoma:        "7988ee6d8f7e730d50bc9cfcfd64e74e0ab1ea55a3bc7c15c0c77a26465aa1db"
    sha256 cellar: :any,                 ventura:       "39d114190c2d2bdeadfff8a47e69db34bfe902601b87885828c6a05a6028da6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba372ab9258777e2eb046834283f37456849a66b05ca41b8ca6af5e2c8622dae"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
  depends_on "boost"
  depends_on "cminpack"
  depends_on "eigen"
  depends_on "flann"
  depends_on "glew"
  depends_on "libpcap"
  depends_on "libpng"
  depends_on "libusb"
  depends_on "lz4"
  depends_on "qhull"
  depends_on "qt"
  depends_on "vtk"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"
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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
      project(pcd_write)
      find_package(PCL 1.2 REQUIRED)
      include_directories(${PCL_INCLUDE_DIRS})
      link_directories(${PCL_LIBRARY_DIRS})
      add_definitions(${PCL_DEFINITIONS})
      add_executable (pcd_write pcd_write.cpp)
      target_link_libraries (pcd_write ${PCL_LIBRARIES})
    CMAKE
    (testpath/"pcd_write.cpp").write <<~CPP
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
    CPP
    # the following line is needed to workaround a bug in test-bot
    # (Homebrew/homebrew-test-bot#544) when bumping the boost
    # revision without bumping this formula's revision as well
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["eigen"].opt_share/"pkgconfig"

    ENV.delete "CPATH" # `error: no member named 'signbit' in the global namespace`

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/pcd_write"
    assert_path_exists testpath/"test_pcd.pcd"
    output = File.read("test_pcd.pcd")
    assert_match "POINTS 2", output
    assert_match "1 2 3", output
    assert_match "4 5 6", output
  end
end
