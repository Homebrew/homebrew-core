class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d82061f57b9b550b7cc95d934e10dfdf0746b1fb16203ae210a95cb026827115"
    sha256 cellar: :any,                 arm64_sonoma:   "ec5fe0a2aa4a9bb58d5b205281ac438f6da35278c37d576e2228c1c373f0d63a"
    sha256 cellar: :any,                 arm64_ventura:  "e165698d107b10d8af68aedadf5d9e4be06c41164be52fb8b7c815f8ae3f0b77"
    sha256 cellar: :any,                 arm64_monterey: "1118ded93339bb313e97d7fd94bd837a04ce042795ce884bbc10749cbefb6ca4"
    sha256 cellar: :any,                 sonoma:         "038ef345fcf1239f9794e8ee4ae178bc9c4a2c397dcaeb6cdd7b32b59b5a945c"
    sha256 cellar: :any,                 ventura:        "380d3b7d65f3bdb3596f4a2e2f0efb3a1e4636f6bbfd6b29dcf63e540a018522"
    sha256 cellar: :any,                 monterey:       "b84610f825a7cddde9031c9af5c85541d257ce8aee5cd61d6c65013462016c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2a0a1f0fc8e65b51ba4b07c3e1cfe5d4d6f13730b0cdf7c5d770d5e7d4bdab"
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
