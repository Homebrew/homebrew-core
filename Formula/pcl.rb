class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "http://www.pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.9.1.tar.gz"
  sha256 "0add34d53cd27f8c468a59b8e931a636ad3174b60581c0387abb98a9fc9cddb6"
  revision 5
  head "https://github.com/PointCloudLibrary/pcl.git"

  bottle do
    rebuild 2
    sha256 "ac0fc06be7ed9e4fa4b8e7ccddc733f6c59d381034c338ca17024a44a0b862c3" => :catalina
    sha256 "272bcee97cfdd53897811265cb1adca2bbe1e5369165fe56577b07b32a015d73" => :mojave
    sha256 "50b77a12bcea32681255b01aea10f843c35056a3cde8597133d7b970b114dc9d" => :high_sierra
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

    if build.head?
      args << "-DBUILD_apps_modeler=AUTO_OFF"
    else
      args << "-DBUILD_apps_modeler:BOOL=OFF"
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
