class NextpnrHimbaechel < Formula
  desc "Portable FPGA place and route tool for Gowin FPGAs"
  homepage "https://github.com/YosysHQ/nextpnr"
  url "https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.11.1.tar.gz"
  sha256 "2af682d94abf3f3e116f2fad36dc7db314fa93bfbb185e63619f2ec4f5fe40dc"
  license "ISC"
  head "https://github.com/YosysHQ/nextpnr.git", branch: "main"

  bottle do
    manifest_sha256 "2fb4a65a416f7c3c5a8874c38815c29db6e722ae2b2011c0ba8affa5f976ad7d"
    sha256 cellar: :any, arm64_golden_gate: "c743deb6b0000cd0b4ebb89779e1e5cb0ec5e0f39296a21342a3f3dd256574b8"
    sha256 cellar: :any, arm64_tahoe:       "1bb8a71df9c5b7be6b67da7642f9a34926eab7bce9cdac396f0e7ecceeb975cc"
    sha256 cellar: :any, arm64_sequoia:     "6af7193a2ef73a9a051a3befdf900fb1dbdc75e6f288ee4adcc6d37177ef2bd6"
    sha256 cellar: :any, arm64_linux:       "a8515195eff0feed5dbcc32bba730847c3a19ac5a74c1862e77aca4fb687ff16"
    sha256 cellar: :any, x86_64_linux:      "8300dd4900314686fccdd7793a402e63c0bb5cbe2ef86e3f1aeb83e7473474e2"
  end

  depends_on "apicula" => :build
  depends_on "cmake" => :build
  depends_on "yosys" => :test
  depends_on "boost"
  depends_on "eigen"
  depends_on "python@3.15"

  deny_network_access!

  def install
    args = %W[
      -DARCH=himbaechel
      -DHIMBAECHEL_UARCH=gowin
      -DAPYCULA_INSTALL_PREFIX=#{formula_opt_libexec("apicula")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"blinky.v").write <<~VERILOG
      module top(input clk, output led);
        assign led = clk;
      endmodule
    VERILOG

    (testpath/"tangnano9k.cst").write <<~CST
      IO_LOC "clk" 52;
      IO_PORT "clk" IO_TYPE=LVCMOS33 PULL_MODE=UP;
      IO_LOC "led" 10;
      IO_PORT "led" IO_TYPE=LVCMOS18 PULL_MODE=NONE;
    CST

    yosys = formula_opt_bin("yosys")/"yosys"
    system yosys, "-p", "read_verilog blinky.v; synth_gowin -json blinky.json"
    system bin/"nextpnr-himbaechel", "--json", "blinky.json", "--write", "placed.json",
                                     "--device", "GW1NR-LV9QN88PC6/I5",
                                     "--vopt", "family=GW1N-9C",
                                     "--vopt", "cst=tangnano9k.cst"
    assert_path_exists testpath/"placed.json"
  end
end
