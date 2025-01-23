class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/refs/tags/3.0.23.01.25.tar.gz"
  sha256 "6dcdada6c115873db78c7ffc62b9fc1ee7a2d08854a3bccea396df312e7331e3"
  license "CC0-1.0"
  head "https://github.com/Oblomov/clinfo.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "04355e178d5678a1a699844ed0de3ffa7d4e6c32c22b98f6143e9c8639b9227b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4349f5759c42841276dd4bbd8ccc5e5dfffae88fab4ecb7273611f197cc04859"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5e47b95c7d64d71af511c63fd358aa0c17baf8643b63bdede9f576788408166"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdab44766ca458a88c221ea4f7449b186b9fd748db904f7eefde045fb6443fb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c1497f49082ece2d52fae1bfc65c5317e7c76a6b2d8272f95fcb69f6068a4a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "50df43e65bf588c3d98290b5a6a1dfa8b51ef24bc8684201880026fa68364a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "2315c5f2eb3c44d67eed92f81680c2b0baef3d4a9d1e95a230b0e8a1664eecfb"
    sha256 cellar: :any_skip_relocation, monterey:       "f1d18a57e2dd034e082d5df7b51ace021b656d6ea8539462a63ed11d8c2157b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "86e27c2acbdf720693e142d25e82f1ccd76a4445d9ed2e25901382735b28d6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e7cd2b464087fe9304644a1c6ba611a3b95ff37387eb85ffa1b495d88030b70"
  end

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    # OpenCL does not work on virtualized arm64 macOS.
    if Hardware::CPU.virtualized? && Hardware::CPU.arm? && OS.mac?
      assert_match "number of devices : error -30", shell_output(bin/"clinfo 2>&1", 1)
    else
      assert_match(/Device Type +[CG]PU/, shell_output(bin/"clinfo"))
    end
  end
end
