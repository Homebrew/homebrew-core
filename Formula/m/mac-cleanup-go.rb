class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "4d939cc1c4d364fa66d3a27189b670d97a89040373a67ca84a9e3c9efb069a27"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f1f340793dd1cf2f1b186d8d85c0a53b2727e4880cffc778fb41f10e1bf3129"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ffe3e7eb5a60eb24aee31f54abca3e6a77e95497f786f911f2a4a9f9a57cb297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9815c53c5f4dab98e561828776429859b3a3e5ef89c3deaeb0509d9859fc61b7"
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
