class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.2.tar.gz"
  sha256 "c2de941c493af4a01f89369d297528e649df38b2e270c29f7b04d245b63bc4bd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adefed8f8d1f381002e735f0c15f059a710afbed3da3fbe76ae90dd35df87a49"
    sha256 cellar: :any,                 arm64_sequoia: "e76857381df9206a6ba44295cba7bf48edb92e8ef27d9cb6ec31c28eed8cb7ae"
    sha256 cellar: :any,                 arm64_sonoma:  "7f15f9ccd93200406121f3513a5ef925280a628c4ef6473242ce085eecbdce6d"
    sha256 cellar: :any,                 sonoma:        "10473affe73c252adebf453d5f85d8bca099ba7ba121697e89da11aa20f583fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "805043f61f438dbc69518b0b7407f434d97651d8cdddb5e7c1ce49d2c4b26c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2364147ce4842ff2091f92ac9d57e3d74130eabcac0c5c79d0643e627a309cab"
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
