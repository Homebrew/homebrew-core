class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.23.0.tar.gz"
  sha256 "8b5f672777aa8ae14d2659b83cc1883fb2db24288f32cc6b779bb816904e3418"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e072282f44d24a1f4b8b2f407447d5053785eb4469aeb1511ff47358c35a949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89da50d339ee0f9c6d3fcc1cf319b9039ccbf418e28bb3938dd51cd1f6b083bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0047f1a840511aa5370bd14106b98c758175cf675788799dd2b62e68afa38f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0ba34a17ef2fd7f8562b4d42aa3a9e58ff194e076a626d27c0f8f4027c093bb"
    sha256 cellar: :any,                 arm64_linux:   "efd3a48baee8c49c5e0078991c78ea472fe32229b91556ca3ecf7ce291955e2c"
    sha256 cellar: :any,                 x86_64_linux:  "cf2a97fb44c6777f38e5e03d606d17a620b6a21a0e695393cacfe5c192dbdba5"
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
