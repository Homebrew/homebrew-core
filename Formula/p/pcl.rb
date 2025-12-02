class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "https://pointclouds.org/"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/PointCloudLibrary/pcl.git", branch: "master"

  stable do
    url "https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.15.1.tar.gz"
    sha256 "e1d862c7b6bd27a45884a825a2e509bfcbd4561307d5bfe17ce5c8a3d94a6c29"

    # Backport support for eigen 5.0.0
    patch do
      url "https://github.com/PointCloudLibrary/pcl/commit/2d6929bdcd98beaa28fa8ee3a105beb566f16347.patch?full_index=1"
      sha256 "66e6b47a2373224f6a64a87124c94fbe79d3624b4cb0d71603c4805323343b62"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bffd9015641e8e0f41a330b289769f391526de7fce302c55b47a1810855c7714"
    sha256 cellar: :any,                 arm64_sequoia: "05c3ab811e06258620ba9e48aed56ebd7554212475bf2edb28b02d733caf70d3"
    sha256 cellar: :any,                 arm64_sonoma:  "ee46a4518eb4226857b485d46713fe174bc1ce94c50b00babb74e7490f88f838"
    sha256 cellar: :any,                 sonoma:        "7c576693ae1468c7a962f072e67a453caf33f33fe9d8aabcd9cdf5606dbc2c49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c88cb862a00392e09048310d551d33f367d691af7320c9c261960bb7a3f7a6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5db03271116649a3db04c7895d4f37cc0c9b8297bd748418e10310570f2736e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
  depends_on "boost"
  depends_on "cjson"
  depends_on "eigen"
  depends_on "flann"
  depends_on "glew"
  depends_on "libpcap"
  depends_on "libpng"
  depends_on "libusb"
  depends_on "lz4"
  depends_on "qhull"
  depends_on "qtbase"
  depends_on "vtk"

  on_macos do
    depends_on "freetype"
    depends_on "libomp"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # Apply open PR to fix build with Boost 1.89
  # PR ref: https://github.com/PointCloudLibrary/pcl/pull/6330
  patch do
    url "https://github.com/PointCloudLibrary/pcl/commit/8dfb0e10ebdf4a5086328b38f854294d2d6b1627.patch?full_index=1"
    sha256 "f31c11abb6bec8864b7a109472768ba80e87ddf90533890c303294d264f389e1"
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

    # Work around ../../lib/libpcl_cc_tool_interface.a(mocs_compilation.cpp.o):
    # relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `...' which may bind
    # externally can not be used when making a shared object; recompile with -fPIC
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" if OS.linux? && Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install bin.glob("*.app")
  end

  test do
    assert_match "tiff files", shell_output("#{bin}/pcl_tiff2pcd -h", 255)
    # inspired by https://pointclouds.org/documentation/tutorials/writing_pcd.html
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
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
