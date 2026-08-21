class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://killswitch.network"
  url "https://github.com/vpn-kill-switch/killswitch/archive/refs/tags/0.8.3.tar.gz"
  sha256 "061f0f8fc7c16178b7e99387fd5498ca5812d7bb95c2931464c5ae6b8c268598"
  license "BSD-3-Clause"
  head "https://github.com/vpn-kill-switch/killswitch.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbefb9623a427619ae2f2e9ee419fc4d683f1ccd58ed7b9f40eff4b7f445be1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5500a22bdfa72f6c3b4165638504feb3357918a829ff9bce8c7c22c025725d83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042ab6e0df1a07f397bf1715222518d891269c3f5007960c9129703065c8abb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "590dec47d367b7d1735abda9485fbe50ecf0d072b9db5402f30e87527399e5fd"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/killswitch 2>&1")
    assert_match "No VPN interface found", output
  end
end
