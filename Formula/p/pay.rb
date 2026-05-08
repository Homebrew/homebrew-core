class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.16.0.tar.gz"
  sha256 "af9f8e8c9f3bda77da4e7f2bcb4d033703c9c62ff374b5001907916976aae6ee"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2719d3b2d530eb0e6ac3aceb01515874641f929e7f9503d3b91006a914d69f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad6cac7773d17020f564862c520d0625e86a816f6eb2ef0df153f15519c0ec8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1120d249339b333d6cd8d8b48ef41741416b2c35ab5563a15e3a7f69c9d37550"
    sha256 cellar: :any_skip_relocation, sonoma:        "e06043443a265c92546b1d529179a136bdd3b758afc3637a8f8ecb03c4d7fbda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "028605107f32c5d71de84bb630c171a7796542cede91b66d05f5865df80f8d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edec7ff0bb3dc9992174931e8abb26c75dac35f978ce3451f477781d77969e11"
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
