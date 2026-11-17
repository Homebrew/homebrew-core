class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.28.tar.gz"
  sha256 "60a059a060e48b8f16575fb94dbd7ac548768f5e16b49e95e52b68d672d7ea53"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "373c5cce4505ce22d68ff99c7d5b59d7abb4224be95f2a9387a6addee8f49916"
    sha256 cellar: :any, arm64_tahoe:       "e85a16dce6d7a194b434e2bbaa5348f8c7461156a190aa5e837b9c9837474b8e"
    sha256 cellar: :any, arm64_sequoia:     "30d11968179f02364d4ac00017a4692439069fd85d8e681d224658e2689c75ec"
    sha256 cellar: :any, arm64_linux:       "2b69d78e268291db17f2f8aa96279e8bf3a6e006ecc1811e5634cde40aed13b1"
    sha256 cellar: :any, x86_64_linux:      "00f909b0012965645d90685d922aa4ff60a5fbaf1296012b65a515f5811ad2d5"
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
