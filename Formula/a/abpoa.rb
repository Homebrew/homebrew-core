class Abpoa < Formula
  desc "SIMD-based C library for fast partial order alignment using adaptive band"
  homepage "https://github.com/yangao07/abPOA"
  url "https://github.com/yangao07/abPOA/releases/download/v1.5.6/abPOA-v1.5.6.tar.gz"
  sha256 "60ef1cb65f8bf914949392e7bb755a92113f6724e9044db2431c64c1287e1c14"
  license "MIT"
  head "https://github.com/yangao07/abPOA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "385dc39ec7ec7ff7b18b1e9f914a5473fd1fdae1f1e0bc2ea7a6fab61790fe14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf194ce866d12e177808b3f5db462fe8e45e9b662a83dd39933599c50e394d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be0b252ac77c5d4753134d8801ab97ed6b145935140b0e19402640db2c0199d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8647decaef2b90818811f34483f13e0a7500eea5330b79265ed860c511a9696c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca4f53634e2fb57b1682ead57b30f37eeea6aef17851ab0ecde89d68f064ad6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f98773ad924e6a5004944605195cadec43bb2c17cb9025ba755cd60cd07ba275"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make"
    bin.install "bin/abpoa"
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abpoa --version")
    cp_r pkgshare/"test_data/.", testpath
    assert_match ">Consensus_sequence", shell_output("#{bin}/abpoa seq.fa")
  end
end
