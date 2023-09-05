class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.8.3.tar.gz"
  sha256 "eaf51b1cedba3e6962bdb1cb5ab42ac992f14110f488f06bb8e74967601945ad"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37463d33cecdf55a3386de68a3ede23cf05ac8814bd7dc741bb88110da750b69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "677857fc74b2e58b1a9cbf9c4e0885d2ad158e1c36c2b726a076cf5a9145df9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9085bf5bd1c852d9149d55568ad2e3426f9462b3b418b014eefdcdf814618b3"
    sha256 cellar: :any_skip_relocation, ventura:        "1c54e67f98856e1b2125a4b2068e7dbcbc16293676b1a84c9c41aaabb0449612"
    sha256 cellar: :any_skip_relocation, monterey:       "c2410c53e1f7bac6baa2b0b78908d15957bbc000e6fe90e8cd241b220977d603"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cdb6fd72442921f45ecc0c1f5865240c47edbf6f4d983fe4180277aa7ca7f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8af07a13427506635bf62413d4c9a32d412155cc5d8ca278aff36e92e71db2d4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
