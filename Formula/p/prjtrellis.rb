class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 9

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b5704b0c94159ae307faa175a626884f5c0c5b93be34ab3f6fff1cd7c6420485"
    sha256 cellar: :any, arm64_sequoia: "5799ecac5726e00270a710bc20b274523c3cfb25f7c2a5dac778f8d1746b29f9"
    sha256 cellar: :any, arm64_sonoma:  "add7029f8281e3069b852b98230a8e557a8e455c0ce90448b7e52697175ab2ba"
    sha256 cellar: :any, sonoma:        "499f952b070fdd2235958873a574e48421521fdaeaf9055fd7fd0b9d3be5c38f"
    sha256 cellar: :any, arm64_linux:   "8e409cbd38a73add5003dea5bca10f086ef24a721fc0a7e0c8cdeb36d9051828"
    sha256 cellar: :any, x86_64_linux:  "cb8ca6b45e91e48bc1a09e4e496392fe2102c47eb9f119aa326b917302116ab8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "python@3.14"

  resource "prjtrellis-db" do
    url "https://github.com/YosysHQ/prjtrellis/releases/download/1.4/prjtrellis-db-1.4.zip"
    sha256 "4f8a8a5344f85c628fb3ba3862476058c80bcb8ffb3604c5cca84fede11ff9f0"

    livecheck do
      formula :parent
    end
  end

  # Fix build with Boost 1.89.0
  patch do
    url "https://github.com/YosysHQ/prjtrellis/commit/e821bcbecdc997d71766836a200e16b27535a835.patch?full_index=1"
    sha256 "22a47fb89f4ed1b501823be12b5ea18bf03cae5f8749cd63fbe6972d8e69d764"
    type :backport
    resolves "https://github.com/YosysHQ/prjtrellis/issues/251"
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
      url "https://www.trabucayre.com/blink.config"
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
