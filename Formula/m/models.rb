class Models < Formula
  desc "Fast TUI and CLI for browsing AI models, benchmarks, and coding agents"
  homepage "https://reyamira.github.io/models/"
  url "https://github.com/reyamira/models/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "748a9a3e349f5397f72f46e6384a194a33ac6c4fe131f0683b20c2ad0ccb3fba"
  license "MIT"
  head "https://github.com/reyamira/models.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69bbb0d0bded1f5ed36960baba7ff0220c740727614fed10c3cd1b83547a159d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "788b361a64131ebcfd60a8bee364d86ab74cbb89aa4041f8953caa74e5ca2260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a452dc004acb647cd8dfe7a81d19423e7a4315f5e279530d1abd5e62ba13af99"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc4cc69a7dd640b7d103c3874e8ccf830f7b14fd9f7d15ddd7b0f436956ae970"
    sha256 cellar: :any,                 arm64_linux:   "4f05f020ff7b6d13ffa8d523797b04678b3d95515a53362e911ecc32e9f3a422"
    sha256 cellar: :any,                 x86_64_linux:  "433ba70f9a810240db7f0849b0a6ccd2ff2d5355b01a93f6407c6e387759b2d1"
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
