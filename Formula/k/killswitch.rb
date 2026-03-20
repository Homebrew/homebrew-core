class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://killswitch.network"
  url "https://github.com/vpn-kill-switch/killswitch/archive/refs/tags/0.8.2.tar.gz"
  sha256 "0a13e6ebe9f05e5cc34959779b7fc078e96246dbc82449c6a8c9ace75ff8b80d"
  license "BSD-3-Clause"
  head "https://github.com/vpn-kill-switch/killswitch.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59f19ffd34d74717e5e4c98a54ff3aea8aea6d8cc930210c1bfa81d06c1ca8ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99c93051e4bedae26eefccc504b3664e747bcfb3e05e0a6d9f29d1d1e9223d86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de4be0598f404fffa4e2d7f842782fa449f0aed07c94ff41af89dc4221515765"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f57f490df220d489d64d747cb124c72997ac18d6d0c1d7f250b3a3fb7373cb"
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
