class Iccdev < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "dcb66f84016f6abe6033e71e2206e662b40e581dce9d208c9c7d60515f185dfe"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3463c07de594a7655097127df1650220d350c21a2451c641a89de4830912ed0b"
    sha256 cellar: :any,                 arm64_sonoma:  "74a5e9869622d29ec0628d8b2e4a0876b6c76cef459996e8b95149916cfff7e3"
    sha256 cellar: :any,                 arm64_ventura: "c07f73bb98c6cc9e528a045c4b4791fa7e8d52ab8c75b2d70589176617bda59e"
    sha256 cellar: :any,                 sonoma:        "a0f7907faf006e2c1ca69fde725ae4ee0f30cfd0fb9f78bb6493e3e93c568acc"
    sha256 cellar: :any,                 ventura:       "87c9c63c090e892ac479df95c0f9691e0baf4cd8546184838a651bd6cff1ae36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee8834db2b2d8ef5414dafca1f900ca8b2ea607256030a00c625bb3cf9c83bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72258b3eb9987fe029fa91a98ac52d5b988c716d7b1f77cbe58d626505a84c3f"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  # Build fails on Ubuntu
  # https://github.com/InternationalColorConsortium/DemoIccMAX/pull/145
  patch do
    url "https://github.com/InternationalColorConsortium/DemoIccMAX/commit/965e14fb0c00dd4638dac6056cce84bab9821b57.patch?full_index=1"
    sha256 "e40a632236e2b3da5df9b2313fee3d79eed601b9f91a81158a67577e0a9d397c"
  end

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
