class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "da39066f6e222340f33e019a07ced34961ed4218ee87a43e833f386926b22e7f"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2032e3456b3337c9f088dc7a6db614526f7164947ee04ccfd340ba4c0c318d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92488cf7cd5c57b2b8320d9b976c94785209104cff31c837e409f370758acb18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdf3f5d6813ecf6271c046323f21c842d3204aa5d282c3cc490aee9bc324a4b3"
    sha256 cellar: :any_skip_relocation, ventura:        "c329ddf66f1ce71ff6fbfd95ca89efcb86d68d735bdada395de07c695489a14f"
    sha256 cellar: :any_skip_relocation, monterey:       "d71e1628a27027b39a90a45a2761fa3095a9ecebc192596c4e62972b73a001f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b03c027fc621722652eb04cd4ea07a5ea2dbab3185eba6fddd86856d8752b505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667911b0cd1a743d9f39fe603937c027f01c4153396d01680116a81f6b98e0c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
