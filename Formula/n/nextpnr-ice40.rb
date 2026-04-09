class NextpnrIce40 < Formula
  desc "Portable FPGA place and route tool for Lattice iCE40"
  homepage "https://github.com/YosysHQ/nextpnr"
  url "https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.10.tar.gz"
  sha256 "374393094cdf7b2aae415cebf0994840b4a355bb95e89c683ef19f95f0b14dc2"
  license "ISC"
  head "https://github.com/YosysHQ/nextpnr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8d35ebf37436515566c1d2dd1bb0a87e9fb11815d1729ed3d0b7a7fb46d56d8"
    sha256 cellar: :any,                 arm64_sequoia: "7d29a823778a62e5316b2a60301e256f9c351ba19c3f2e52b0b3b8932c37ded3"
    sha256 cellar: :any,                 arm64_sonoma:  "db90d1891b3bb2a427704793460190973b4a4f9ee9a93f0c5c702ec1026e2e96"
    sha256 cellar: :any,                 sonoma:        "4842370686c14ab5cfd921120c8f1bd8f9773103420d58acc65afce1c89785a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e274bb3f988d996725a644c6461e3a6d0d4e90328cdafdda635141e0774f542f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cefe1fa9d3b1b178e88c74eb073512487d5f0874c72c13b7ea0452dce528dd7"
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
    yosys = Formula["yosys"].opt_bin/"yosys"
    icepack = Formula["icestorm"].opt_bin/"icepack"
    cp_r (pkgshare/"examples/blinky").children, testpath
    system yosys, "blinky.ys"
    system bin/"nextpnr-ice40", "--hx1k", "--package", "tq144", "--json", "blinky.json",
                                "--pcf", "blinky.pcf", "--asc", "blinky.asc"
    system icepack, "blinky.asc", "blinky.bin"
  end
end
