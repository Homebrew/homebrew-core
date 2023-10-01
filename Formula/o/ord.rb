class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.9.0.tar.gz"
  sha256 "8b66d4c9ba2caeb3458a6abddde18595c9d825352b95720d23ed57c107e081c2"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffe624b6a4ea136d7019ad1cb23dbc056b4716660aa1d5556baa60f64f86e88e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "911b973fbb7e0a84975c70a7430845176265c2f2ba94c6da1275013059bb4987"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e54fabdb185aeb6ffffd5b951963ce3afcbc76278944d132a229d57c3314d33"
    sha256 cellar: :any_skip_relocation, ventura:        "64390de3aaec097fca7426b37ff87f57e35107b4fde21bf10569ff269e48ce1a"
    sha256 cellar: :any_skip_relocation, monterey:       "4ee6e29dcb608a91fe3b8df84cdf8abc952b8129a224992ac562c62949f29c07"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4f22034998c5df50a41010acdf2f00e39aa5c7907a818856f99f26182d1f7ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8cabbda464192b7e2b5e18fd281d6a8d266a15e7ff38deb8040c0b2bb34dffe"
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
