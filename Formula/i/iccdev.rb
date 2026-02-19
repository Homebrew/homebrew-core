class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.4.tar.gz"
  sha256 "7889fd4544e1d224700aa68659a83847b24a8adaa130db1d64e8577098b8700a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3a2415a4004ff4b359ecf3f8d02590bc5ff2e2bcab94b0120c9003cc93dce06"
    sha256 cellar: :any,                 arm64_sequoia: "64b39503c5f5c1ed2d9c148fdc4d82752234148f4a0a70679bffee5e4572d158"
    sha256 cellar: :any,                 arm64_sonoma:  "c0641832a827aff9e6a2fc803ddb1a8b38287557d3afde36cbd493f02c96d53f"
    sha256 cellar: :any,                 sonoma:        "a8acfce3879fc2e83240518bd41b3ca10a019c9af9a355f030cc21f95586b62d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc4233afbc41f83d2da1f490701f93a4298538e2d23b7f6e9ff72bf59a06d725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f50e82cb25584e2e3450f8cff4d9fe88c4ad829a9a4cfd1ea11786f873bce7"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg-turbo"
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
