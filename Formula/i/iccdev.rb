class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.2.1.tar.gz"
  sha256 "9e990e38881d34d0c31aa7f0035d62376c3f58a6d0d891723663b35776090da9"
  license "BSD-3-Clause"
  revision 1

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "05d8a438907b41a25ea05594453d709dc30138bff710bdffa27476d6c791a28f"
    sha256 cellar: :any, arm64_sequoia: "23321c818f6727afb1cecb11f53775452c3ed8199ada664aaef859461a55baa3"
    sha256 cellar: :any, arm64_sonoma:  "7e8ba416a721d356fa1663c003ddf0d025cd87c843b83e4052aa655862909766"
    sha256 cellar: :any, sonoma:        "97ca9c6e45a370015ff8588ddc15d235a820f1b45a6152a7f60971cb42fd67eb"
    sha256 cellar: :any, arm64_linux:   "a6a64168d3b5be4802874030fcf9ec25886b1185ca4c94cdbccad5344bb38961"
    sha256 cellar: :any, x86_64_linux:  "43819f16f430e0de04f438d2e8ae6f352485e7425e88a531373347b64629b6b2"
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
