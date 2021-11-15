class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.5.0.tar.gz"
  sha256 "39c9686bdfcfa96b6bb1d8b37a8a53732372c16cda562036abe9930b61b29e97"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "648e0b46b3111791b7b30de236fdc8edcb0118e122d87cef7017b64751db5e64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77483712fb4bc07885f71696245d13d3bbb34255db2e94188588345b52f81866"
    sha256 cellar: :any_skip_relocation, monterey:       "6a71a65727b492748b5cb8ded309a519cc0f332eeb43a609b494812266c8ece6"
    sha256 cellar: :any_skip_relocation, big_sur:        "33f9a2c0324595ab30136b1f83e5b97db844c362f7b5543fa009796145f23f42"
    sha256 cellar: :any_skip_relocation, catalina:       "01322e5f63e499776d44a32f7752b71c7238f633e51ef46d46a5b8aaebc73929"
    sha256 cellar: :any_skip_relocation, mojave:         "759abeb1d7b64b34f216518ffebc9584bccd6eef7003c29eb11740cd49c38549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30a0f2f57e76b8e667eecdf85281fc619dcddb9d8e6f3b2ba7491bb01ca8fb8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

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
