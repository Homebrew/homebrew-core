class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.10.0.tar.gz"
  sha256 "966b4629df86b1d520ddd8a4e0a3fc00060b26b5ab4e172b596bd9d4659a196e"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4b309035e824959bfc0a802e0d4f31501082e1508fbea0c622ec95576220a5c"
    sha256 cellar: :any,                 arm64_monterey: "0a8a0865cee8216b22463607eef522eb9b5a0530f55e8cf2946890f8eaca49f4"
    sha256 cellar: :any,                 arm64_big_sur:  "206a214c5ca198b8e105d3311426965b8467bee1bc5f4bd2dcd32e3927d40ae0"
    sha256 cellar: :any,                 ventura:        "d32d70c3674b960046f995f1014bd299f7446c9b052f1b4d114eedb80bd80157"
    sha256 cellar: :any,                 monterey:       "48bb9db99d81f75cae462f7097e6c9f76b8dba57ca4d2752353323111bac957b"
    sha256 cellar: :any,                 big_sur:        "178b66c07d0c8241f131f87225369e674cc3a900b2e40edb41c475affccb17cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "666014c49ff365fcbd120ddbbf0569b4044c521133985e09acc44c35bbda6d6f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end
