class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/v0.8.0.tar.gz"
  sha256 "9073d96afdab56ff51f392cffa8d04fd70d47602236bd10e58248de5594bfd2a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "586f6e8b98e82c9684e6e40faaef2e76650ff1f8d28cbcf73c5eec2d7e32ce52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2e1d6a11c8e3a68434a7b201d75864ae2bb52e66818bebae8e300680b89d004"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce4f5e090a145e3e8668eff23ef5c3e96490992cafa3584689d300f32b8a4ca1"
    sha256 cellar: :any_skip_relocation, ventura:        "b39b884380eb96d46df3a1b8449d4c13aee99597c723c0b72bb3d05b5451ee53"
    sha256 cellar: :any_skip_relocation, monterey:       "851b3fd79ae8365d7ee5bb75230b9ede1d39f12993413e92bd1d846cc2062847"
    sha256 cellar: :any_skip_relocation, big_sur:        "376447e0fc60cbf980224b66030a4fcd7454e47bebf96044cc0bc3ff7ea6d96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ed48064b265ff9b7b847135d6fc8532b4c9fadd51b18c632aa92042c58b78d6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["AICHAT_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end
