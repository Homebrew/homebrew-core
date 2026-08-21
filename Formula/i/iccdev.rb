class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.2.3.tar.gz"
  sha256 "0748d2759b5c010efa84faf1820d9743f88adf79f4d3dc740651a7b579517e62"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "917b5909f944246b9e9093eaf5f6a124f1708d7fc334036b6c4ac37eadf43e4a"
    sha256 cellar: :any, arm64_sequoia: "202a8c00a26690ed456723e05c812b2b4fc94bcaffab645c3967b6d3931b245f"
    sha256 cellar: :any, arm64_sonoma:  "79d49ab254744b22ee1ef3bc679bcd5714b35ca44559614352f939bebb53bdc3"
    sha256 cellar: :any, sonoma:        "57d4dd57501bec9075f035d11c855c042cd415a27769e2d17a429a4d4b4948d3"
    sha256 cellar: :any, arm64_linux:   "b231cfb681f280049f9d7e1749976274272de6ed9b00f1eb88ad9a7aff67899a"
    sha256 cellar: :any, x86_64_linux:  "b4d5d14c0c706f716a68261520cea6e22eb1145ee1105277760b057716d36d02"
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
