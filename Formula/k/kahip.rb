class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.29.tar.gz"
  sha256 "cf7f740000a8b26ce5568951a2847d4169b9b394983d7b5d1d77c9887183063e"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "de20cf302ca30ae56a19995819582e17b84aa13df3d531776a88dcfb7aa74ba3"
    sha256 cellar: :any, arm64_tahoe:       "ab27d035afecc463f7ddfb5e4be4e21ffc7de4d480906dd6781b46233feb6654"
    sha256 cellar: :any, arm64_sequoia:     "d34533e393f1fef5d6d75a79b05a5daa8180f6964be8c8ac4f6af14895f8e43d"
    sha256 cellar: :any, arm64_linux:       "cff85ddcf852d1c8917d9e44b79a1083081d2e096b197bdf5932104f60215056"
    sha256 cellar: :any, x86_64_linux:      "6febb6c74b05f44d3d410470be58713a21f947e9bb09e6a3e49557d2c35705d4"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "mcp-toolbox", because: "both install `toolbox` binaries"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end
