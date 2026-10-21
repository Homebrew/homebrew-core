class Prjtrellis < Formula
  desc "Documenting the Lattice ECP5 bit-stream format"
  homepage "https://github.com/YosysHQ/prjtrellis"
  url "https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz"
  sha256 "46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147"
  license all_of: ["ISC", "MIT"]
  revision 10

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6430f4541d908c19834b67477da8d756230469e040d0b66d5ebfaf4a90c30bc3"
    sha256 cellar: :any, arm64_tahoe:       "57266af60eccbcdad436dbd72412e267fca9694936a0cf039e2a6d88e879f673"
    sha256 cellar: :any, arm64_sequoia:     "a431c3b257ba19d73d658611309c74b3a83189a9d44478f3168fd0be3ac7a88c"
    sha256 cellar: :any, arm64_linux:       "bc230beabaf50eed71be3f6f5f152e0f7c41c805f608af9e8342916ec8ecd3b7"
    sha256 cellar: :any, x86_64_linux:      "b0f8c2c083a4fb6ebfc23ed1c93918436af4917f6d0af9a9c5ee7e755250047e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "python@3.15"

  resource "prjtrellis-db" do
    url "https://github.com/YosysHQ/prjtrellis/releases/download/1.4/prjtrellis-db-1.4.zip"
    sha256 "4f8a8a5344f85c628fb3ba3862476058c80bcb8ffb3604c5cca84fede11ff9f0"

    livecheck do
      formula :parent
    end
  end

  resource "homeebrew-ecp-config", :test do
    url "https://www.trabucayre.com/blink.config"
    sha256 "394d71ba416517cceee5135b853dd1e94f99b07d5e9a809760618fa820d32619"
  end

  # Fix build with Boost 1.89.0
  patch do
    url "https://github.com/YosysHQ/prjtrellis/commit/e821bcbecdc997d71766836a200e16b27535a835.patch?full_index=1"
    sha256 "22a47fb89f4ed1b501823be12b5ea18bf03cae5f8749cd63fbe6972d8e69d764"
    type :backport
    resolves "https://github.com/YosysHQ/prjtrellis/issues/251"
  end

  allow_network_access! :test

  def install
    (buildpath/"database").install resource("prjtrellis-db")

    system "cmake", "-S", "libtrellis", "-B", "libtrellis",
                    "-DCURRENT_GIT_VERSION=#{version}", *std_cmake_args
    system "cmake", "--build", "libtrellis"
    system "cmake", "--install", "libtrellis"
  end

  test do
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
