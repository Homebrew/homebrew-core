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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7dfc7b02df09d2149fc4cf60aa6b6bab37f203276445b88aaf29265b5c648a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df3181121baff1afd2b047f204a569b78eaddc4c3738a8f7b6bb1f6b0326bb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d6310d5a09168194d2e164133ade109efc5c50f1ef1f716d3cb1db0ab560503"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d5853cbc725c0720678374e2412cde4b8d2136f03c25a780d9698b08448c6e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcd9f3e29abad83d42ac27c076362ae4f00cf64244b676e2db93aa1abec95ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff73d5e51f91d0cd7852d5bd2455e6621bc015a8ce545ca56f00f612691ebdb3"
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
