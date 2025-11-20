class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d434b22f04c894203cde92c60e9a590b0a6705c942f23572e13e3274d5da6c78"
    sha256 cellar: :any,                 arm64_sequoia: "5b635498be6f03183c07cfcba9a8899f198a3e16f1cb3bd6f28d12e3397535fd"
    sha256 cellar: :any,                 arm64_sonoma:  "127bf1deb554d1b774f44c715e447f35dbe6a106018c089a6534a6407d4c6b30"
    sha256 cellar: :any,                 sonoma:        "fae45ba6ef1c1609955ff57f8d1d5c7e9cc93e6a645ab098b51dcb768119f052"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0619301afeacc7f18b3696d9a15ec3ac4fc64b27b36cb3fd3e839e202d6f86d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ff0873946edc0c0e3a84d0407bac877bfcd9ac48012c30bea94ca29155cc49"
  end

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
