class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6bc4a360866f5170cf35fa4724a9b2cb41c28b130fe44ce0e527e5d4a64350c1"
    sha256 cellar: :any,                 arm64_ventura:  "6912bae90999af698d4943daa52afc2354c8a29d3f9c9063b0bb24819f96bb1a"
    sha256 cellar: :any,                 arm64_monterey: "7a48a3e2134e3c54473eb657cc0a76dcd8c0d2414a6587e13e912eb2c161a8aa"
    sha256 cellar: :any,                 sonoma:         "3e4ab876da7d52945c4fc083019c0203638eeff3c39601580ebfb3fb3b05ffdd"
    sha256 cellar: :any,                 ventura:        "06b6cbb58cd2760de77100131868a016b673671ba2ce62cd1bd9592d319ed6f9"
    sha256 cellar: :any,                 monterey:       "73c484c35fc52d6cbbd0cc19ca2426ba6a3a1d819d26b04513baec998514f4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "432afb462ad23f6785ad820ff5765e2f92311a3edb2b815ab76320c28d3616f0"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "python@3.12"

  resource "prjtrellis-db" do
    url "https://github.com/YosysHQ/prjtrellis/releases/download/1.4/prjtrellis-db-1.4.zip"
    sha256 "4f8a8a5344f85c628fb3ba3862476058c80bcb8ffb3604c5cca84fede11ff9f0"
  end

  def install
    (buildpath/"database").install resource("prjtrellis-db")

    system "cmake", "-S", "libtrellis", "-B", "libtrellis",
                    "-DCURRENT_GIT_VERSION=#{version}", *std_cmake_args
    system "cmake", "--build", "libtrellis"
    system "cmake", "--install", "libtrellis"
  end

  test do
    resource "homeebrew-ecp-config" do
      url "https://kmf2.trabucayre.com/blink.config"
      sha256 "394d71ba416517cceee5135b853dd1e94f99b07d5e9a809760618fa820d32619"
    end

    testpath.install resource("homeebrew-ecp-config")

    system bin/"ecppack", testpath/"blink.config", testpath/"blink.bit"
    assert_predicate testpath/"blink.bit", :exist?

    system bin/"ecpunpack", testpath/"blink.bit", testpath/"foo.config"
    assert_predicate testpath/"foo.config", :exist?

    system bin/"ecppll", "-i", "12", "-o", "24", "-f", "pll.v"
    assert_predicate testpath/"pll.v", :exist?

    system bin/"ecpbram", "-g", "ram.hex", "-w", "16", "-d", "512"
    assert_predicate testpath/"ram.hex", :exist?
  end
end
