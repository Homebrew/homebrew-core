class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.17.0.tar.gz"
  sha256 "cb55623c0be1b26c9ca84d6ae491c8dcc628e45a0ffed4b2ac3b5a5e3158c38c"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bbbc9a23dc8934130dde46f7d97c4b66c75c96e441e31c03bbb1d0026ad4928"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18d6316ce298a3bfa45fed5c88483c7f8ee5d207d7d548a68b3614e1071597a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e82f46172fccd2e14129f12d64b32312b731e7b99cb63469d71567b008d91e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "af89d9e69ba4b13b53cc7f04238584c5fa0e7586cabde4b96d7db07e8695cd93"
    sha256 cellar: :any,                 arm64_linux:   "36576d07b0fa81c4f7741b526dec5170929f1e0ae93561f894aa8f3652db5d53"
    sha256 cellar: :any,                 x86_64_linux:  "a9d5fac8d3f424608d1f6f199878f416911c660d7b29491485263f24bb079fa7"
  end

  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "python"

  def install
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "No pay account configured"
    assert_match expected, shell_output("#{bin}/pay --no-dna fetch https://httpbin.org/status/402 2>&1", 1)
  end
end
