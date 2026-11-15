class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.20.0.tar.gz"
  sha256 "85a1dc9e60e8ebc22ffe161cc08cb998f18f5e27b7e23319f35328a69a95fd10"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6cfa5f2da73d1de20a2e5ac468087be030deef6a0bceab0fe8851d5adce0d57b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0e38cdc14a1c56d2f6f66f04f9d7441a9d7fa27fbfbbd3388710734c10ecdde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6efc7bf4a38b82faf5b9cfc9d18a9bd6a648bd7e808e4267d2bdcf23ba686b2e"
    sha256 cellar: :any,                 arm64_linux:       "c34d8d842b6f4d8d1f99b3281a0b563994cd807cf146e69bd32c247071faaac0"
    sha256 cellar: :any,                 x86_64_linux:      "11105ab497a9b70e746240ac7ebaae55e75fabb91e16f7a84dbde841a0d49858"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
