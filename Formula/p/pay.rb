class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.30.0.tar.gz"
  sha256 "8d3ba79f8553193d35ba419dcc20c968a069c51cfc497e3d84047285d6276ebf"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27cd48ffbf394edeac0ba104ce51b88b289abcdae1f277dd4a2a1dd72f14b647"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "46a81cfcb524956fa6e29a3916de97f0c38bceefabd0f73a0b9cc6bab7a5f7c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16a7012f872d061960e9e5e98b7539e71cee083d173d1cd200c00f386ac55879"
    sha256 cellar: :any,                 arm64_linux:       "9b2c13f6090c13da36e2107499bfc40170df49f59e85d1a968a8c16408e7920f"
    sha256 cellar: :any,                 x86_64_linux:      "5fc400ebac38ddcdd0fc204353f2b5aac84f983d55cb047473048d11a957f104"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm@11" => :build
  depends_on "rust" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "No pay account configured"
    assert_match expected, shell_output("#{bin}/pay --no-dna fetch https://httpbin.org/status/402 2>&1", 1)
  end
end
