class Pcl < Formula
  desc "Library for 2D/3D image and point cloud processing"
  homepage "http://www.pointclouds.org/"
  url "https://github.com/PointCloudLibrary/pcl/archive/pcl-1.8.1.tar.gz"
  sha256 "5a102a2fbe2ba77c775bf92c4a5d2e3d8170be53a68c3a76cfc72434ff7b9783"
  revision 1
  head "https://github.com/PointCloudLibrary/pcl.git"

  bottle do
    sha256 "18efc3f7b897d0f646d8d1dd6512f41cc6abfba296b1dfed2927823e78b60b81" => :high_sierra
    sha256 "46229b4eb3d168ecaff4f83dcfff95642a05d0ff989ab89adb63ba0397c4a909" => :sierra
    sha256 "176fb1d15c2dfbb323eb29d28929624bcf342a09dcb848f610af652e89ba5ec2" => :el_capitan
    sha256 "bd0b24e10b74ba20d63c09af7a1292d70d8c9ff8f7ffae98fabf4591993c09d4" => :yosemite
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
  depends_on "homebrew/science/openni" => :optional
  depends_on "homebrew/science/openni2" => :optional

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

    if build.with? "openni"
      args << "-DOPENNI_INCLUDE_DIR=#{Formula["openni"].opt_include}/ni"
    else
      args << "-DCMAKE_DISABLE_FIND_PACKAGE_OpenNI:BOOL=TRUE"
    end

    if build.with? "openni2"
      ENV.append "OPENNI2_INCLUDE", "#{Formula["openni2"].opt_include}/ni2"
      ENV.append "OPENNI2_LIB", "#{Formula["openni2"].opt_lib}/ni2"
      args << "-DBUILD_OPENNI2:BOOL=ON"
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
