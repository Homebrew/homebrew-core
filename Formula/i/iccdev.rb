class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.4.2.5.tar.gz"
  sha256 "aecf543f58b61bf3dd86c87674960d99ec0a7949b81d247106831945eb78ed34"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6022e967ff7c38ef4a542b9b28273150de744006be95551ba00a3c333b2fec98"
    sha256 cellar: :any, arm64_tahoe:       "8d94f9af590215e04aee8bcc7c2473a19d5b0717d9d94bd0eddc6ca062b1bb25"
    sha256 cellar: :any, arm64_sequoia:     "39270898403ce95a70a00a055281e6a901f346af62ed79d408d61f296fd8bedd"
    sha256 cellar: :any, arm64_linux:       "caeee63a4f3f20cea6431b2d0a6fc692decf2ddd43b1eada21687dbb6e847da1"
    sha256 cellar: :any, x86_64_linux:      "d9058a5314d6551b343bed4f7f7b9a157c939e3221d10447e0a5f772e71bed34"
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
