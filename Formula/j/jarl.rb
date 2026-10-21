class Jarl < Formula
  desc "Just another R linter"
  homepage "https://jarl.etiennebacher.com"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.7.1.tar.gz"
  sha256 "f1974b1f8082fcfa44b5e9a755e8787f9fedd6aac63147714a46a29b80d85ffe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce4654b9bea5aa5b5a0ca325a8fe18f9b7ec91895aa7c9858fee1732f0a542a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9572e0cdd3cd1d29d45269ba2f55cb0d8c7714bf130f854d98730e948be50da7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61deacb0a5dbc82146109355c98e3c4d419d785cee312f4c45ee0bf3275eb5c9"
    sha256 cellar: :any,                 arm64_linux:       "e2e7a50ee9f44021856ea6d3befa48f988353d1d69fe3a1777fd9e1dd2805f4c"
    sha256 cellar: :any,                 x86_64_linux:      "dce2c3b696ba39c05666cac94f3c24f476f28dfae178da7f3c65bb3a90210cdd"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jarl")
  end

  test do
    (testpath/"test.R").write <<~R
      # Simple R code for testing
      any(is.na(x))
    R

    assert_match version.to_s, shell_output("#{bin}/jarl --version")

    system bin/"jarl", "check", testpath/"test.R", "--fix", "--allow-no-vcs"

    formatted_content = (testpath/"test.R").read
    assert_match "anyNA(x)", formatted_content
  end
end
