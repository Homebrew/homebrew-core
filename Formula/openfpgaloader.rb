class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.7.0.tar.gz"
  sha256 "1731e54eabb49c03f58a9ec5c3fea8d5d9123d68268a3e14301bb42604f273a8"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49d3017c044706af630bd2125f0883c81225a82518baef07392611679fe5eac3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96dc786d5469c0d9913d24c9430ba63fd5dcf8528a75059997ad602d1462549e"
    sha256 cellar: :any_skip_relocation, monterey:       "83b6ef344380a9a447584f3f763d960107f55f49d9d10e89837334e9e56ba62d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bf217f173377c31b8de36c116bfc44b6cc39233cdf122ff46e22e9953509810"
    sha256 cellar: :any_skip_relocation, catalina:       "a40497005165585313fd67573940309133274e6061e5329af043694a9e64e623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ffb8c28305dde7b303dfba51a4eb5386493266d6b2919f254606b4b4ce2b693"
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
