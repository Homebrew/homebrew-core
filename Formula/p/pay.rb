class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.13.0.tar.gz"
  sha256 "bde6bea2bb39b2ba8997d8719fc7e42d10b7cc2239dd756fd29ed16601cce2df"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6675c5ee16cd000a37fc734a82d314852d8b9e2358a8616ded3af2c622d97635"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "285b4d91ef51c03e2a5cecb53ba2379791454aceed53bbe2a4369d0051dd35fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2434595db0d9b5f7e7592b823b0d203c2fefcd731f9e50efbf40408f26086b96"
    sha256 cellar: :any_skip_relocation, sonoma:        "700bebe83afdb4f4dd5b0ce491e6adf49a0f34c834d5bd15c22d9c1dcc9eeb6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f367a933b808284da7b7dbe2b7f109a73a755fa2bcbc4477ee43caee20a2fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16c9e4592965ff30e3d949b38092cfc309ad1671c821fd02cf96ebfb37e8c893"
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
