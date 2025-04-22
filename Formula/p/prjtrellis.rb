class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b1dba8073f95e4e62578867fa4413c96546ed01af8a9368dd71f226e242f824"
    sha256 cellar: :any,                 arm64_sonoma:  "c88a90c50cf9b1118812077911e320ada13ad47ca5e26bb9b71cea451cc83935"
    sha256 cellar: :any,                 arm64_ventura: "528c6c2f526e1a8a9a6374a27740ec190b09e2cd8d55166d7adb8954e5f481e5"
    sha256 cellar: :any,                 sonoma:        "17166123d4960d5612ddd664fb46a4728162fae98327f379b2940ea05dd5cf61"
    sha256 cellar: :any,                 ventura:       "66fe4759bb1294f951a36d578ed68cba116539ddbd4bb71cf73c0f5bc2eca105"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2244c986587aae3a6d6feb0b89d8e2650999ebad9cd3b6f77fe138b1f0b326e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a091d4126aff828ab290e08cf68316f68a7952fb192482a993ab4484dc21a5b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "python@3.13"

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
    assert_path_exists testpath/"blink.bit"

    system bin/"ecpunpack", testpath/"blink.bit", testpath/"foo.config"
    assert_path_exists testpath/"foo.config"

    system bin/"ecppll", "-i", "12", "-o", "24", "-f", "pll.v"
    assert_path_exists testpath/"pll.v"

    system bin/"ecpbram", "-g", "ram.hex", "-w", "16", "-d", "512"
    assert_path_exists testpath/"ram.hex"
  end
end
