class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "cf19b596e5dea21891b1be3cb9a04be7a1501926ee0919dcc5c9f1b6d3bd0a96"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "67fc3d927fc175b1d6458606e8b3f65051ed206b10502581e8d3b39c2b7654c8"
    sha256 arm64_sequoia: "c5621af8a41a347e8e4fbb87b37c55832334ea681ddc5ec3cf4bfb2b93d1011a"
    sha256 arm64_sonoma:  "9694df81e287cbef5007d2cff991222533050950de65ff9c8946331052c1e643"
    sha256 sonoma:        "172c7a00da927e1e406c8a5d5a156ed4352c85ec6e4bcb9ecabb34a8631cbfba"
    sha256 arm64_linux:   "68fd7db44386badf4b396d1fa07553ed27c49a66a1c391a4ca110b4dc4b80f06"
    sha256 x86_64_linux:  "3b928bbbbda0981095ee18bcf3dad481e33e436706054805fd362bfac20dcecb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"

  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd"
  end

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
