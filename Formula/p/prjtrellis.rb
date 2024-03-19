class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "30488a14075b849c38abad9433fcf9cd7c4185b7a4c7b6fc9f69907ef1149517"
    sha256 cellar: :any,                 arm64_ventura:  "5e16fee0522b5e85a51d5ebe2076abdb82c78cafe8d4de42d04953e383e21ed0"
    sha256 cellar: :any,                 arm64_monterey: "d919f2c6e7e96e6d470e60875cbcadd88bf0ca6b02c95c540ea3142d6827511c"
    sha256 cellar: :any,                 sonoma:         "2d812e47a21e44d8d3eb2eb47d00989b4ce60937d18950b96996502a398f2d11"
    sha256 cellar: :any,                 ventura:        "8b3a265cffe872c69aca33e7f344664842e68396b5892073b5ce016ffa46db19"
    sha256 cellar: :any,                 monterey:       "14f9f9a6be40b5b8361941b5447b1886c21928a6a4526cf35d3b4e15d8ee814b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d754001388c77e1c0375917183a4ba9ab0bd579b298d259b4ca8d61cfb76f6c5"
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
