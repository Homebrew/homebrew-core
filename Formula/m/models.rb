class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "ae065a6a839f54a08e220a960636f349890b34ca75f0ba76cd6bb5fbe4677deb"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2a89b4a27a48272c3a244e72e9e790c584c4bb673ecefb3bdb114a3760b67e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab50f75b4b9a089603b22be5d7b62c0c72be89e14c6b05714ee56d3105a41a03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58467588b604faada096250612c96940defe8de51db63351ff570bc5b4a20201"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2cf189afe46db689f75141cac3bea43dc62162c4bdb8e543e0a956c9b011a0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb060a0728773531f90eddb6711538bff974ff3eef77d38cf7db6491b71ec7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee8d09752f9293a7ed1b6bbd257ce67dda0fdd48fe47d9ead13b2c72dcc2be95"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")
    assert_match "claude-code", shell_output("#{bin}/models agents list-sources")
  end
end
