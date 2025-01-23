class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3fcf3ad5a10549e1de32c6c296af661f30b8c651005310777fef3d9e84e2a4cc"
    sha256 cellar: :any,                 arm64_sonoma:  "7efc22584a244817fca20fc8f3a19af1630932d72d166d0f6dcf096ac2b599e7"
    sha256 cellar: :any,                 arm64_ventura: "c146035dc653ecbe88c38f3ed237ded5feaac5c614c8f86ce623f94e950fe01b"
    sha256 cellar: :any,                 sonoma:        "50514ae38b2cccdd1dd9d2249c807c631a28f00dfe8dc54df01562162a0b38c7"
    sha256 cellar: :any,                 ventura:       "b66e7fa03d996662fa0737a573c7a35b2f90ac43fd0268836aaccd33847fbcf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d96199f848fc43cf9160e1c0c66eb699985fee7069cb41a5de90f970764bd15b"
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
    assert_predicate testpath/"blink.bit", :exist?

    system bin/"ecpunpack", testpath/"blink.bit", testpath/"foo.config"
    assert_predicate testpath/"foo.config", :exist?

    system bin/"ecppll", "-i", "12", "-o", "24", "-f", "pll.v"
    assert_predicate testpath/"pll.v", :exist?

    system bin/"ecpbram", "-g", "ram.hex", "-w", "16", "-d", "512"
    assert_predicate testpath/"ram.hex", :exist?
  end
end
