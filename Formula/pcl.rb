class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "http://www.pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.9.1.tar.gz"
  sha256 "0add34d53cd27f8c468a59b8e931a636ad3174b60581c0387abb98a9fc9cddb6"
  revision 4
  head "https://github.com/PointCloudLibrary/pcl.git"

  bottle do
    sha256 "09a416e3c1a928846a3e546cb5f222ab2c4ac86b3df254783cfe05161aa90009" => :mojave
    sha256 "76d9b5efd92a6b5b3206badc39a12e512e6774e6c46febd1c7946faf31357b9d" => :high_sierra
    sha256 "11255d960843127fafbaa9be1fac996ed2c400ea1a83f6c85b44b5dcc5de6843" => :sierra
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
