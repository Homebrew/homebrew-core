class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.27.tar.gz"
  sha256 "5c649af08b1200c9f97424a3e86c3fceb8eea0eb2d0489f09f405e080521c0e2"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7bdbabcbc1ca5d5021197e19ab7cc71f19925d3803028047539e7721e633ffb8"
    sha256 cellar: :any, arm64_tahoe:       "50075c73007c0f7c0d0d4c3813b2d7933b738d2bf2e5cbab62cf2f0d3a6b0614"
    sha256 cellar: :any, arm64_sequoia:     "b75535ec0fca4aab52b968f7b5d437642f785cf8c5fe0852fef37f8e24e3a84e"
    sha256 cellar: :any, arm64_linux:       "4e42082757b66b1c1d72736aba77e604f660b18e2eacb361c9bfed87d784cd59"
    sha256 cellar: :any, x86_64_linux:      "55bb43ae61c8ddf5d0c270c41fb433864e2fd480186071aea8dcd82786fd3380"
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
