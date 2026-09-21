class Jarl < Formula
  desc "Just another R linter"
  homepage "https://jarl.etiennebacher.com"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.6.0.tar.gz"
  sha256 "86620fcdb654d18be5f9fc62257ff577eade56cb1a6d9a3bc7d6e6857006a8a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "159ea09b9cf96752e6e14f423fa7512b1e49526225b7aa67634d932ca061602f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "250cca749284bb1768d23615d9db03eb293778b02be42186d7a29f5fd4c51aa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7759fbbad7c27cb27bba8aaeab19528c895ec06e5ce773fe7d99a32bf20ec6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1caa14c3afbaee337af068fa3ada16b4111318e3b318ea0c5bcb1985e16143d6"
    sha256 cellar: :any_skip_relocation, sonoma:            "e819335dd3711f7a1c579fd0877c9a092b1d4488df34b8da9a4377e84bd23e04"
    sha256 cellar: :any,                 arm64_linux:       "2ec448c693dc075a2946c9e1444c7573e5cf8a10aa3fed45feb722d0c503eef1"
    sha256 cellar: :any,                 x86_64_linux:      "1216d951f2b6c9dbfe3c272408722fd64c891ed2c542e9e1b977d8a8dea7fbad"
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
