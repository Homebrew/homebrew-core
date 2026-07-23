class Icestorm < Formula
  desc "Tools for analyzing and creating Lattice iCE40 FPGA bitstream files"
  homepage "https://prjicestorm.readthedocs.io"
  url "https://github.com/YosysHQ/icestorm/archive/refs/tags/v1.1.tar.gz"
  sha256 "928dd541d15540a796a3d320122794d8d76acff90783de8c5747f613e474652f"
  license "ISC"
  head "https://github.com/YosysHQ/icestorm.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "889af14b52d5f6026719f4b9bb9c3784a7606d82de14495a866c505462e26646"
    sha256 cellar: :any,                 arm64_sequoia: "9035439404af379e44d3d44d29c804cb756c7cb7d68bddde57cc55fedbf24635"
    sha256 cellar: :any,                 arm64_sonoma:  "1d452cc8ca983e9b1d5a7417e973eb443c2089b90ef305c8229c6b240db77bc2"
    sha256 cellar: :any,                 sonoma:        "4e4a217126b1b28f352c6fd8adc18cee56eb845860f7166142a08c098c6a56dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "184fba3c4a42f84dcd393ca66c962a4a0eb3dbfb7e3f1a47b71e76e064e01373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0392bd42c618e66f60e675c88988133bdab5f28637e9382f554b78cecd38941"
  end

  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "python@3.14"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    (pkgshare/"python").install bin.glob("icebox*")
    rm bin.glob("icebox*")
    bin.install_symlink pkgshare.glob("python/icebox_*")

    mv share/"icebox", pkgshare/"chipdb"
  end

  test do
    (testpath/"test.asc").write <<~ASC
      .device 1k
      .io_tile 1 0
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
      000000000000000000
    ASC
    system bin/"icepack", "test.asc", "test.bin"
    preamble = (testpath/"test.bin").binread(4).unpack("C*")
    assert_equal [0x7e, 0xaa, 0x99, 0x7e], preamble
  end
end
