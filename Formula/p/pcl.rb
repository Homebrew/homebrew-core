class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "https://pointclouds.org/"
  license "BSD-3-Clause"
  revision 8
  head "https://github.com/PointCloudLibrary/pcl.git", branch: "master"

  stable do
    url "https://github.com/PointCloudLibrary/pcl/archive/refs/tags/pcl-1.15.1.tar.gz"
    sha256 "e1d862c7b6bd27a45884a825a2e509bfcbd4561307d5bfe17ce5c8a3d94a6c29"

    # Backport support for eigen 5.0.0
    patch do
      url "https://github.com/PointCloudLibrary/pcl/commit/2d6929bdcd98beaa28fa8ee3a105beb566f16347.patch?full_index=1"
      sha256 "66e6b47a2373224f6a64a87124c94fbe79d3624b4cb0d71603c4805323343b62"
      type :backport
      resolves "https://github.com/PointCloudLibrary/pcl/pull/6354"
    end

    # Apply merged, unreleased PR to fix build with Boost 1.89
    patch do
      url "https://github.com/PointCloudLibrary/pcl/commit/8dfb0e10ebdf4a5086328b38f854294d2d6b1627.patch?full_index=1"
      sha256 "f31c11abb6bec8864b7a109472768ba80e87ddf90533890c303294d264f389e1"
      type :backport
      resolves "https://github.com/PointCloudLibrary/pcl/pull/6330"
    end

    # Backport replacement of `vtkRenderer::RemoveActor2D`, removed in VTK 9.7
    patch do
      url "https://github.com/PointCloudLibrary/pcl/commit/4db3dc4f6588b1ba8a807087d8ed6c48d56b1a6d.patch?full_index=1"
      sha256 "7a148236c69bfbcd1c6fca97d3285f743d800e993ae0f14a956b3bd2bfd469fe"
      type :backport
      resolves "https://github.com/PointCloudLibrary/pcl/pull/6394"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "96e7ff3c0b608fb8f47fcb84fcf91cc735f4abca956829f9394ce88dc194a78c"
    sha256 cellar: :any, arm64_sequoia: "bafd5a622108d37dd359b1c50c39d9a63c1416e797bbfbe5f7d9a8b2a58bf9f1"
    sha256 cellar: :any, arm64_sonoma:  "292397594a7af0748192d22fbacaa58700ec145c871c7b369f851a58f935549e"
    sha256 cellar: :any, sonoma:        "3a8e65473a20d68437902ce34ddd27de79219c08ae4ed03de674141450fea7f6"
    sha256 cellar: :any, arm64_linux:   "ee362f427810c10491cd09d7bb6a7c082e2fd1185b2d1d78a1492e26b43b151a"
    sha256 cellar: :any, x86_64_linux:  "2de32c8abdc01f93a0574e6f7e923ee166a96b789dc0b3397663638786d91b9b"
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

  # vtk 9.6+ is optional to x11, it doesn't link transitively and so here we need to add it as a dependency
  patch do
    url "https://github.com/PointCloudLibrary/pcl/commit/490996e66d36829394e01c19089385f23fdf3c9c.patch?full_index=1"
    sha256 "f71b64ce5e8e606a5f57b3c011d961b625ace6c0c8956a7a25db1d4db8446664"
    type :backport
    resolves "https://github.com/PointCloudLibrary/pcl/pull/6435"
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
