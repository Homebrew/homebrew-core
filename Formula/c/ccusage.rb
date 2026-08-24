class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.20.tar.gz"
  sha256 "24f81ac3dc5ca049b4170256402d67675fe7c2aa084274326726acf5cfcc8428"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c84d181f3e5f9d3df164dcc3840624e34c452705a50254abb04e4732a99b22ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835b8e9d9381c10ed37b126722923888f70ec4ffd3f15918d7934026cdaf33bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ea76e3fbf7d7484ff69ac0c5a19f389b1cbc8f691ec88bb18b178a9eb304c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0df8ef3c85ced8359f8a353fc1913f42b0398b9e751e4263649090ade5718dd6"
    sha256 cellar: :any,                 arm64_linux:   "36b6d34be3aea8175fa0a4bfc0d676bbe86be166bc3768638a0187a6fcf339c8"
    sha256 cellar: :any,                 x86_64_linux:  "284834c9b537ed294bd15133e48714f5ef4c0570d8ffc6a01ee7d227f0284c5e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage", features: "fetch-litellm-pricing")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
