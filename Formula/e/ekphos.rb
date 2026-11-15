class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.nostacks.xyz/"
  url "https://github.com/nostacks/ekphos/archive/refs/tags/v0.60.20.tar.gz"
  sha256 "1f2d2e6a55a7870b25a977f02a715390f8f5d93fc2bbd805ca2e3a94a71f8649"
  license "MIT"
  head "https://github.com/nostacks/ekphos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c92f6d8e746cb19162a200625d87c9f42ebc92f4bf2bc6e100a96a9b8e7d23e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1cbcb94dbcb6efa3cd565b36e49f3ccdbb11d4d7c9ef12b56adb9dfe48c56f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87ad0a14f5515897e654b169249b31e89def39ffd404797824e76550d34a541a"
    sha256 cellar: :any,                 arm64_linux:       "4ec1444a6f976ad2d6d61c2d4c30bdc50c46b84c2d10c71d1d218c73c54c25ce"
    sha256 cellar: :any,                 x86_64_linux:      "7433371542f8399f7ef3c1eafbfa9b18313da89d8432ec2675b3b3bd79fd6596"
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
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end
