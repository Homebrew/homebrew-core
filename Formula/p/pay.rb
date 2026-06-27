class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.20.0.tar.gz"
  sha256 "e3b8f2b011039f2c96dfc065c3e8a513907336031838ba7204d317d848b7f501"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c33b7822020a4b447e958c26c492ca30883872e1d39758246298d2fd850ec686"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39516030e74214fff751df270df0b2564e2c2ad637a63a61b2fb2c74af4598c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca55f95ecec74e30fc58b4a9f8c0d341c13c3c98dfb903867c79c2359f63876f"
    sha256 cellar: :any_skip_relocation, sonoma:        "926563801a600ef679672187beaea9e8c702aa950c3166ad36d1723005bed5d6"
    sha256 cellar: :any,                 arm64_linux:   "87223b2e0d84c1c6e922e3162c3029eccc734419cefebac14f133fdd03bf4c15"
    sha256 cellar: :any,                 x86_64_linux:  "804f13f86c2653ac140118d1871282d4aefd9b9aa1d24b892d506d4e483bb948"
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
