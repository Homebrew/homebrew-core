class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "bcb836a1ca6b2dba8acb2927ee8d9c07a0ceb51fa01e1901a68922fdd323adb2"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    manifest_sha256 "c59716f3d921361ca46b6084b45567d0fd3dc1cbaea59f752e287e665f2734ea"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "503ec71e283291b1a45524ffb332da60616e95e6a9143a706bb39132bac06eea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f19cbe40f27971d619b6576c8fb3535502fba1248a967b1f65d749341949118"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f325530492f951b874e27b852bfcf7feca99ce40a669ac4abbe0631396028d5"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"mac-cleanup")
  end

  test do
    # mac-cleanup-go is a TUI application
    assert_match version.to_s, shell_output("#{bin}/mac-cleanup --version")
  end
end
