class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.27.0.tar.gz"
  sha256 "20fa4b1e6d45e333a1fa1dccd18c1be63ca1e8a0285daca437897b536cf34efb"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37627370b54aad328846a235ae00d66c628bea2b43954ac92a1d8b38a648e2fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e01e495c5fca2523ef43cf82bd94deb7f7ddb160b5179121db94d797a7399eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bc3788d24b2f647570e8a26c707119c16c72ffcfd638de93ca65ee17e80e42a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b1bd61122a8f3fceb5ab9ef062b6578e86fb3d68a16ed05d2f933c1d1d18735"
    sha256 cellar: :any,                 arm64_linux:   "f5a1b6b04e868da1ae1315c285211e39351ffa93db8af3408a4d673f2c566ab9"
    sha256 cellar: :any,                 x86_64_linux:  "8d8e290e54c626fb2969c7fff57cbbfbcecb0745fc2a41270b229e7e30a2d396"
  end

  depends_on "cmake" => :build
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
