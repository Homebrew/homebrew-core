class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "2672e6a99d4579fb4bb32d9de0d63aa424ce600d31fbfaf06eb74d940d2e07a6"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "25af6b36948c45f5ab5f2a2c2b2fab7899296bbdccf85619bfbbbf505f0138d4"
    sha256 cellar: :any, arm64_tahoe:       "085dc6048a48155e76e00a37dee769ae04f7c55b0416c2554d0ac4a07353a026"
    sha256 cellar: :any, arm64_sequoia:     "6976f4f5e065110e4c22a20c0194cffdb4a4f586b07ed9ff2a3bafd2c6864507"
    sha256 cellar: :any, arm64_linux:       "677a7114dfb2b14b2e5be78bcb5bd0d3b09b2cd5868c982c932585bfcd4c09c8"
    sha256 cellar: :any, x86_64_linux:      "69c309c660538e46d293de71291f41727f614547f1547804775b573658a9b3e9"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/blocks\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end
