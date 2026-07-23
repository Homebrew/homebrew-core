class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.18.tar.gz"
  sha256 "464b060118cfae0d4b96e0a6979d306389ebf9d84ceef5967deaf9b3b142f653"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5eddaaa4bbe2fba5a4823e9b7bde697962c96f8fd94b6dd39bc6ee62173ff95d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31917d5c448d2f2e4c2c8ae7adeec0a88625d2eae1a9e7e07b87c7a54f0fec1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd511aca4f6251a939874df124b8098365cd19a738c2a662287ad9de95ff6dd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1cf6c6bc0b56a5cd97530da3e1e742444947c8e08f1702e04e213f9c31c9963"
    sha256 cellar: :any,                 arm64_linux:   "752463a7ba1ed30ed6832bf5aa9a0a4e12bd19a43bd41f844fe28d85cad70e1c"
    sha256 cellar: :any,                 x86_64_linux:  "59fda055aeae4c8d59f93fd0dd825addf71522954f154cc22837346de03e0cb3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
