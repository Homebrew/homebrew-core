class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.6.tar.gz"
  sha256 "166bd8205ab47d41335a6972ac4706dba71a0902f20ad3d7a2e885f002ed0155"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72c1d869ef12638a4b89c56527f0625e0fab18768c0c2ba5d90f8ffec1f1f3ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d46f7e2c4ec0ec5eefe18e201f97dea014a32f9ed8b44dd3de0fafce5480ea04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4a658edef0f3cc77e9aa6186e804af0d6f713ef0faa4bec4e34e44f665c0f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cb39d9f53d77d9e72bc3f2dacd7be56382d282ffdb720dccf6d3636b44eb258"
    sha256 cellar: :any,                 arm64_linux:   "05be2f9e4e6b1783a585d47d9c83be455dacef2bdcdf2562337ade7472d93f5f"
    sha256 cellar: :any,                 x86_64_linux:  "65d16a7cef98cfa32b270140eba1669678132fc821a7c97476fae91fd9ab9bf0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
