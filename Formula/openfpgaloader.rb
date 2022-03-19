class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.8.0.tar.gz"
  sha256 "1d94c2b40c4d6b22d4099ef48b7ed4cb3f3ebfc73f36b1e87c739418a7d3045d"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43db5211329882015e05638df81cc06f5a44059d0cf0d3f580dbf7a67ce9c192"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cf67baf0b24ab5cbb3a7dd219e6ba7fbe28b33b1f965c80331ba2df34a1680e"
    sha256 cellar: :any_skip_relocation, monterey:       "5c673097b0073866c23f2aba73ee628305176afbc0919d8d2fd14daa72f8a2a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c697ec94f05025839553f165f582184d56eab5fefd85045b675d2011d1626694"
    sha256 cellar: :any_skip_relocation, catalina:       "7117e2c912d379f25d7184a9de3d0296d896ce5985f54328b4dd45fa012d6b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9af88379296eca9c8b5e7645685f9bd89ec9c0de142aee8201d18921bdd3417"
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
