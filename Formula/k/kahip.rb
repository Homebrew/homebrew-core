class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.30.tar.gz"
  sha256 "9fe214ba2978951fdc75b3f4f2dc944e3279bb1ddeac32ae097121310b1c5c51"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    manifest_sha256 "f382f9a9e8bb3c37e09989f2a16a426c210ec75fdc6c71910642a7f33ed12958"
    sha256 cellar: :any, arm64_golden_gate: "bafbd1629a63a7e889be9786839abd25ded4d8d5b0500a4915953bd4c00aef55"
    sha256 cellar: :any, arm64_tahoe:       "5b609518b6236b398ce070d4b8fd1b6f171964769706f46614481e06175b3a2c"
    sha256 cellar: :any, arm64_sequoia:     "8746696d57849c67c25666ffaede113633601672cc553ea8f178e7d299f1c597"
    sha256 cellar: :any, arm64_linux:       "9de736af3757de08c1cd35524c9f93d0faf38aa742c11409950d900e3811dfee"
    sha256 cellar: :any, x86_64_linux:      "36bf0b44caeae2fda572766f01b8fd661f10b3b140d2c0e135c1a0404faf9c03"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "mcp-toolbox", because: "both install `toolbox` binaries"

  # Fix missing `prefetch` in fallback `ordered_edge_map` on non-libstdc++ 11/13/15 toolchains
  patch do
    url "https://github.com/KaHIP/KaHIP/commit/bab6e0c2ac6dd47fdc77bf04cd02dc9da49c6dca.patch?full_index=1"
    sha256 "93961fa87839e824e489d453fe2f2ef743729295c65ddfd84295b386e8827b2d"
    type :unofficial
    resolves "https://github.com/KaHIP/KaHIP/pull/191"
  end

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
