class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  url "https://github.com/iamrohithrnair/emeraldian/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "2d6911759dcf947cac9428b1b83ee12114057275d15353219288af6d2ad47cc0"
  license "GPL-3.0-or-later"
  head "https://github.com/iamrohithrnair/emeraldian.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "727d9d8f2f285287e446d948f71632301926ae35637d38e6e26e217b1b315d08"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f07da147ea199df1e3cd9c2f5d4e1899e539f79d5c9c8f36c4401163c2ccc867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f955c0884ce450f6ee1d9731474d1f8312742e9402a69a31896534a7a88d57a"
    sha256 cellar: :any,                 arm64_linux:       "506439bf6ad7e5e66603030af7778ff911ef1c5d9a3669d92e5e4bbd0ac5197d"
    sha256 cellar: :any,                 x86_64_linux:      "b3f787495471aecd6b2aeb40725e980ab97a289e750edcdafe579072edf61eb7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/emeraldian")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emeraldian --version")

    assert_equal "No vaults are registered with Obsidian on this machine.\n",
      shell_output("#{bin}/emeraldian --list-vaults")
  end
end
