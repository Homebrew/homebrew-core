class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.1.2.tar.gz"
  sha256 "d6935ada948bf6f63121ef91866304047a5781d19e7ea43c18c290515a76e6a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff53d717037457da0882859bb157ad4904ff4344ab05375cdf87796ca4dae0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7e16015191d796cab9637ae255176164c605cb6f717ef80c33d71932e62d5e1"
    sha256 cellar: :any_skip_relocation, monterey:       "b287ffbfa0d2d1e46a62b4980d5ed6a4db7f1c17229fb7f6b8a88949003efae9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a6f2ce67eb6ecc65d6351962d5ce2b0007b37f0d6ce63efc5fff73cc44ec48d"
    sha256 cellar: :any_skip_relocation, catalina:       "4abda43fa59f5b435f9271e041c02095c3781d0a0ef2924d553b01204c230e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db537652b33e1c2c2d32efcb84f96beb37cdf977feffb4f8ed19503006b8b976"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
