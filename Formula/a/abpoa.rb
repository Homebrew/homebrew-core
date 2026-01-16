class Abpoa < Formula
  desc "SIMD-based C library for fast partial order alignment using adaptive band"
  homepage "https://github.com/yangao07/abPOA"
  url "https://github.com/yangao07/abPOA/releases/download/v1.5.5/abPOA-v1.5.5.tar.gz"
  sha256 "2e2919dcadbc6713a6e248514e2d9e9cb93c53c5b36dd953a2909ad2e3fa6349"
  license "MIT"
  head "https://github.com/yangao07/abPOA.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "193726357f31962a176b28e7616fe993acd775b286359c63d6224973c1c939ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "689ef67875138bd5e8726b3c6a169fb56878057b07e861062e664c03d4cd7770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe22809a4dbd7882b8dd3d2d7ce5d556ef59b7b1f9e4c9811b94579c116c4614"
    sha256 cellar: :any_skip_relocation, sonoma:        "c21b07d695aec084a6b9e64ed5deff172907dbaeaa494b6ddf7dbc3ed41638d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d12ebfc06f1359e96e7975e73832cbcaaadfa7b636df4e90bc7fbd78c52f0a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "215a8929dea50b7fff307c3950aaaf658ad29a303d8172fe0d24c375b6599e5e"
  end

  uses_from_macos "zlib"

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
