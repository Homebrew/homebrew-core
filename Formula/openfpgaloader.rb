class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.8.0.tar.gz"
  sha256 "1d94c2b40c4d6b22d4099ef48b7ed4cb3f3ebfc73f36b1e87c739418a7d3045d"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d5aa0dabfedf7425f462a5bacd32e249d19c2762c36adcd3cbb04b07d25f160"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "307a7a664358b43d6281b067af97ee7dba47095929118d16ab4ecaeccc4e2fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "c4f6417721e855b3b19ac481db833c9ddd16188f43f5012ab903ef41788cd738"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cb1f8ab058d833c7b744290bfa97ee31ed3b67ad6a5a7ea3dbb39000a077758"
    sha256 cellar: :any_skip_relocation, catalina:       "fc6fbb2bf1056f376901db3f246cabb6b685abfe5c11177721cbba43a9a765a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd15f028b4ad1c4a89d4eaa582fe6c652a24e6c3a143b477b39c136474d38848"
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
