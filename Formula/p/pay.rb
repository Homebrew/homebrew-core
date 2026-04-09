class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.4.0.tar.gz"
  sha256 "63f0cc9535214a16ab3fa3d546a1d83d01114e46677605d74c4e6a1f04264d96"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7386605e511ab16b1e06f215c4c1b9098b3398a800c11bea84106caed8375bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c90b0381ac0a41af7b4fa2cc0752b08bd473891ae9bb8c6bcf999cf2e8b4059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb09c19b052b8b585574d3772d3be6f18eddba8847f477173b2bc5064bd440bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b26c0bde9c51099ff49bcfaba6cc210507bd41bdfdddc827ec72f888d1e38b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10952b7cb4163bd0fbbcdd432a8e193a91d83a6a1ddf140f6de1e11e606e1b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0d228a319224d82ecc226326976b5d64e563402328583f9fd59b90eca97ae0e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match "No wallet configured", shell_output("#{bin}/pay fetch https://httpbin.org/get 2>&1", 1)
  end
end
