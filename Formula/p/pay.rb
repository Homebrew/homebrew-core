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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8465ab5649aae1b9aa592fa9c844645362d0465e7c6808a0f94f55387485d6a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "afac88c1000019786518d13526196e1c2fd4de3030d1101f9d721996fe33ec4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "32b557441ae9e21d92d2629cce9c6892c50ed4c210dab8c3815450b222bb2803"
    sha256 cellar: :any,                 arm64_linux:       "38326689ba6834dc832e2817f5fc544ba2c9f819c6a01aaccefd20a6439ee27d"
    sha256 cellar: :any,                 x86_64_linux:      "3c904bcdaaba99b81c3016be6b24b5e69651cf9dc1050bf94c68dbf448248029"
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
