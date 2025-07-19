class Iccmax < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "dcb66f84016f6abe6033e71e2206e662b40e581dce9d208c9c7d60515f185dfe"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "848ee717590c4281070e64950f3bb50448876eb5eb9e0befa3281e551d796c59"
    sha256 cellar: :any,                 arm64_sonoma:  "a890aae068114d8001fbb51009a03e67ab874381e8a8d4d6493cee21c84fb8e9"
    sha256 cellar: :any,                 arm64_ventura: "b1c7ca97f7911d654eddb1d020c85a274dbaf1694928818679772e5ed283bd1b"
    sha256 cellar: :any,                 sonoma:        "2b189c5b3c1b92d0cad6b64d7d942c15dee808d1faf97a431eaa05d6721ece1b"
    sha256 cellar: :any,                 ventura:       "e2c1c60c29a8f2551b7c634039e28db0dd81bca3474784490c9622104284b5d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20ee1858ed79286e4b4c3b367cc7960b5bc8f9cd4265650e5612860f0ed62039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73820992ae2d259462278125bb555843ab3cccd767fba192903a2f082b1da32c"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "nlohmann-json"
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
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
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
