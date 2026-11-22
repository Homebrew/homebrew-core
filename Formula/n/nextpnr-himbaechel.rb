class NextpnrHimbaechel < Formula
  desc "Portable FPGA place and route tool for Gowin FPGAs"
  homepage "https://github.com/YosysHQ/nextpnr"
  url "https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.11.1.tar.gz"
  sha256 "2af682d94abf3f3e116f2fad36dc7db314fa93bfbb185e63619f2ec4f5fe40dc"
  license "ISC"
  head "https://github.com/YosysHQ/nextpnr.git", branch: "main"

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
