class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.2.3.tar.gz"
  sha256 "0748d2759b5c010efa84faf1820d9743f88adf79f4d3dc740651a7b579517e62"
  license "BSD-3-Clause"
  revision 1

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dfc00808892abfebefc348e9db6fce3c6f349bd3a20cf3851e4fe74dcc1842f6"
    sha256 cellar: :any, arm64_tahoe:       "9f97d2e565a33bc9bb3ae4b760e31f34330145001b373c7a4bcfc44de49aa4bc"
    sha256 cellar: :any, arm64_sequoia:     "e5b8c30310656d3d67497386e575c91a6bdd8599422d4a05b00faaeffd598883"
    sha256 cellar: :any, arm64_linux:       "e7a4c15007c9610c901ab392af7a27541602d4ed017f55d7349a420ccca67493"
    sha256 cellar: :any, x86_64_linux:      "8eb53684f54a5a501bb303b4d5f7b379656d5e32f4cef637f662acdb5b39b7e7"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
