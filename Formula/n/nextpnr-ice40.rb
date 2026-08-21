class NextpnrIce40 < Formula
  desc "Portable FPGA place and route tool for Lattice iCE40"
  homepage "https://github.com/YosysHQ/nextpnr"
  url "https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.11.1.tar.gz"
  sha256 "2af682d94abf3f3e116f2fad36dc7db314fa93bfbb185e63619f2ec4f5fe40dc"
  license "ISC"
  revision 1
  head "https://github.com/YosysHQ/nextpnr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "06da19337d5526520681227e15b7a67a60add9a4deef6c96b7a12e8248fdff4b"
    sha256 cellar: :any, arm64_sequoia: "21172ef4af4a7b965b33a811b7399d0ece75a9a6bd5cbbdc731e35e7e17f9fde"
    sha256 cellar: :any, arm64_sonoma:  "6a3bf25630d719bcbe77000d92ea2ce177c091739af3e1ab46620480d82b8d45"
    sha256 cellar: :any, sonoma:        "5475075b5e67b7edce0671caec59b011787a7c2003cfb4f77b5687e71835e887"
    sha256 cellar: :any, arm64_linux:   "af1abce4aa122decb55f37a2835a1c9bb1aa2596b482e42ee05646ce499c2eeb"
    sha256 cellar: :any, x86_64_linux:  "44d5867bdfd66a47ecc5afa81343a1daf0394b88f1367e53d2d05711589885c4"
  end

  depends_on "cmake" => :build
  depends_on "yosys" => :test
  depends_on "boost"
  depends_on "eigen"
  depends_on "icestorm"
  depends_on "python@3.14"

  def install
    icestorm = Formula["icestorm"]
    args = %W[
      -DARCH=ice40
      -DICESTORM_INSTALL_PREFIX=#{icestorm.prefix}
      -DICEBOX_DATADIR=#{icestorm.pkgshare}/chipdb
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ice40/examples"
  end

  test do
    yosys = formula_opt_bin("yosys")/"yosys"
    icepack = formula_opt_bin("icestorm")/"icepack"
    cp_r (pkgshare/"examples/blinky").children, testpath
    system yosys, "blinky.ys"
    system bin/"nextpnr-ice40", "--hx1k", "--package", "tq144", "--json", "blinky.json",
                                "--pcf", "blinky.pcf", "--asc", "blinky.asc"
    system icepack, "blinky.asc", "blinky.bin"
  end
end
