class Icestorm < Formula
  desc "Tools for analyzing and creating Lattice iCE40 FPGA bitstream files"
  homepage "https://prjicestorm.readthedocs.io"
  url "https://github.com/YosysHQ/icestorm/archive/refs/tags/v1.1.tar.gz"
  sha256 "928dd541d15540a796a3d320122794d8d76acff90783de8c5747f613e474652f"
  license "ISC"
  revision 1
  compatibility_version 1
  head "https://github.com/YosysHQ/icestorm.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fdba6727b9028fba662c2c52f826cab7852e2533e415156add6fba0c5f72c191"
    sha256 cellar: :any, arm64_tahoe:       "16d3eb61d416359779ab3686db2a2761c2557e7fa3d472a3a291aea191f95d38"
    sha256 cellar: :any, arm64_sequoia:     "5f22368099b4364bb74d9d8a2c14e0193a76a0699c1096e1a4c2236d197dc67a"
    sha256 cellar: :any, arm64_linux:       "5f7f97c344b00a1dbc4e68966fb690c9d45fe8cb24176b24c1a9b63c5436b0cb"
    sha256 cellar: :any, x86_64_linux:      "5f009f8e4a25f80f657ef911b4b89b515cd0a45867bf78d08c1d6ef7306b6300"
  end

  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "python@3.15"

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
