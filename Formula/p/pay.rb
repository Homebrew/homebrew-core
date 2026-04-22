class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.6.0.tar.gz"
  sha256 "d9244bb901af3bdc9125d32ccc34e9e2064ed40ea88580b0a3cfb89d60c34362"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d247cd9096126c7f456c16bea41e7a092c7081ef539fb2619b16882643148d3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72e310def7165098fb7a0e15d0a53e1ce97535821005d467c6de5ed0009512c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6620c71819fbb86a096367cd89bf2fe52ff829f43600ac5261f597b041f50f8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4bea46ef3493b1f3afc2d2b14ec28d8faab93d6177fc0e90bcc1b6c6c95bc4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b3246aaca8b38186a226bf1420b3e00f29ab70331c9b6a304479cbf8269a8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6639250300bb3e9599efccb35970adc6ebdb8df2a7b980386fbbc07b1e57810"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "no recognized payment protocol"
    assert_match expected, shell_output("#{bin}/pay --output=text fetch https://httpbin.org/status/402 2>&1")
  end
end
