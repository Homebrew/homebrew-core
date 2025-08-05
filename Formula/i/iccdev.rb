class Iccdev < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/tags/v2.2.50.tar.gz"
  sha256 "f48fc2e3f4cc80f9c73df27bf48fca3de7d0a81266d7084df544941e61b37eb2"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_TOOLS=ON
      -DENABLE_SHARED_LIBS=ON
      -DENABLE_INSTALL_RIM=ON
      -DENABLE_ICCXML=ON
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
