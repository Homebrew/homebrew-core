class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "https://pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.9.1.tar.gz"
  sha256 "0add34d53cd27f8c468a59b8e931a636ad3174b60581c0387abb98a9fc9cddb6"
  license "BSD-3-Clause"
  revision 9
  head "https://github.com/PointCloudLibrary/pcl.git"

  bottle do
    sha256 "f7a89d9b04578cbfcf21160d5ebd78fa6feeab3ded876678b7bfc23f989a8f2e" => :catalina
    sha256 "593a588bbdce10f083057cb56a2c66abd632f066ab90f35c40facf6b152ee5b9" => :mojave
    sha256 "d14889b636e81d1427a7d0300c028b571ac038e54b3760eba8900a7175d210c1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cminpack"
  depends_on "eigen"
  depends_on "flann"
  depends_on "glew"
  depends_on "libusb"
  depends_on "qhull"
  depends_on "vtk"

  # Upstream patch for boost 1.70.0
  patch do
    url "https://github.com/PointCloudLibrary/pcl/commit/648932bc.diff?full_index=1"
    sha256 "23f2cced7786715c59b49a48e4037eb9dea9abee099c4c5c92d95a647636b5ec"
  end

  def install
    args = std_cmake_args + %w[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_apps=AUTO_OFF
      -DBUILD_apps_3d_rec_framework=AUTO_OFF
      -DBUILD_apps_cloud_composer=AUTO_OFF
      -DBUILD_apps_in_hand_scanner=AUTO_OFF
      -DBUILD_apps_optronic_viewer=AUTO_OFF
      -DBUILD_apps_point_cloud_editor=AUTO_OFF
      -DBUILD_examples:BOOL=ON
      -DBUILD_global_tests:BOOL=OFF
      -DBUILD_outofcore:BOOL=AUTO_OFF
      -DBUILD_people:BOOL=AUTO_OFF
      -DBUILD_simulation:BOOL=AUTO_OFF
      -DWITH_CUDA:BOOL=OFF
      -DWITH_DOCS:BOOL=OFF
      -DWITH_QT:BOOL=FALSE
      -DWITH_TUTORIALS:BOOL=OFF
    ]

    args << if build.head?
      "-DBUILD_apps_modeler=AUTO_OFF"
    else
      "-DBUILD_apps_modeler:BOOL=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install Dir["#{bin}/*.app"]
    end
  end

  test do
    assert_match "tiff files", shell_output("#{bin}/pcl_tiff2pcd -h", 255)
  end
end
