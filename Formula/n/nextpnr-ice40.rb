class NextpnrIce40 < Formula
  desc "Portable FPGA place and route tool for Lattice iCE40"
  homepage "https://github.com/YosysHQ/nextpnr"
  url "https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.11.1.tar.gz"
  sha256 "2af682d94abf3f3e116f2fad36dc7db314fa93bfbb185e63619f2ec4f5fe40dc"
  license "ISC"
  revision 2
  head "https://github.com/YosysHQ/nextpnr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d97901ecf10487fd92f7f34a193e1e0698499ca040003f9841ce676d42bc5f7a"
    sha256 cellar: :any, arm64_tahoe:       "7f02efbd0f4bc7f93ffe34d0c640b59fc0cf942de0831832e39a880f6fe11e11"
    sha256 cellar: :any, arm64_sequoia:     "3b43f3393502055f80869b1f9a4da0dfd12ea09e26dcfc334e03ed3eddf79ab0"
    sha256 cellar: :any, arm64_linux:       "84f4dc9f9b0703b535b08fbd277702e0ae7528521bfb0f749df49bcaff0c844a"
    sha256 cellar: :any, x86_64_linux:      "1d081f85065dc8535c8e9fb85ee16b99a2cc6f04be83d4ad4aaaa3daa9906fc7"
  end

  depends_on "cmake" => :build
  depends_on "yosys" => :test
  depends_on "boost"
  depends_on "eigen"
  depends_on "icestorm"
  depends_on "python@3.15"

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
