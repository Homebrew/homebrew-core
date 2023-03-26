class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "1584dc6a8092b9f621b95fcc98b6d011b07d7249cf4156a9355d6a8bd131acbf"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c564144960781d9dae4d702c3c130d9864103ff110a3f2a4a6018bacd18b82ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e1abfe4b85e1d6519e8004ad50410c66bf6b206ec531c77776822b03177a01b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50b426986ab721883d87720f71e8942c5fed2ef25dc6968a26de84f2db1a8bf7"
    sha256 cellar: :any_skip_relocation, ventura:        "866038d3af78453f450ef055f8913ce900a4a1fa1804cf6886ec7479ce92a8f4"
    sha256 cellar: :any_skip_relocation, monterey:       "69cf4943d5c33471bf41c3362540c1b7dacbce881ba706faa89373b06bc7ceee"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f26372be409e32c01abb44cdf43d9f3b99b4995be90459373ac0be90d8f004b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84064026ff2a4f16c75c8042a1994079711f7940dca123cde7d1ad07c4c5fd73"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
