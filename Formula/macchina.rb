class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v5.0.5.tar.gz"
  sha256 "f8cd45546f3ce1e59e88b5861c1ba538039b39e7802749fff659a6367f097402"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736398b856ca7f7c84d83a16e4ec53a07e5ecb7ba825128e61c1c6d180ea493b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f3214a6b896f736373ba08db08a4bb339e9bbfda5a714f610d38df909dbf03f"
    sha256 cellar: :any_skip_relocation, monterey:       "385701e537f02e32975fac6e2b4b8d3ce431897b38365fe97bb9f3f6dd69078f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e586ea4de6bd869f71545c9fcb754bd4884b2261ac5a55aafd580869353e68e4"
    sha256 cellar: :any_skip_relocation, catalina:       "b6c5a91ce003e6528d7538c30716c48c051e7ac9fda45622b02d3c6cc76e7b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78bce5f51102d1f12368d57711efd6c7d67d38d77d3d3c915454f47eb408bee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
