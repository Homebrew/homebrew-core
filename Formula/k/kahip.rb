class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.16.tar.gz"
  sha256 "b0ef72a26968d37d9baa1304f7a113b61e925966a15e86578d44e26786e76c75"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0821739473246533d6043038f905d07cfd071224b1b201a88f572930895ec64e"
    sha256 cellar: :any,                 arm64_sonoma:   "970fe2a3d90298de2d44a30bce8a60f9bbcf2e0be59f2035c617d825fd4713e7"
    sha256 cellar: :any,                 arm64_ventura:  "3ba222ed29cb5e903167de8216be60180d41a0f59d64edcaa00955e7c7670e0b"
    sha256 cellar: :any,                 arm64_monterey: "ecd60dda8182bfcbd93e030c93d42f7bdca84e36e4bb1a0e0b11f7c64637387e"
    sha256 cellar: :any,                 sonoma:         "e4eebc7fd9b608923efe1e17d006ffe7fd0a00261e3ee72239f5b744dc042a44"
    sha256 cellar: :any,                 ventura:        "26def65973de379722881a0a714458586b23bf5e45fb9632252687de0cc49355"
    sha256 cellar: :any,                 monterey:       "c3c24dfa4c3607db5b3de5a68123606c3883180cbf8436415e180a65d4c58f56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438e8df826b458d6401fc3ddc7326b758c281597bace27f9a542a87389a8c60c"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "needs OpenMP support"
  end

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
