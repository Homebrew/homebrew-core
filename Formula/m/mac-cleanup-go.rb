class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f4421c5544697a827909e744537289510f5a68f21743cebeec0766a11c38b007"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63245fe17eda2208d7f1cbe3ea40c5812b72b157a8bcc508396d4f1e15099182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bae657cb8ce500d9eb3bec631b4b1414e900b4b23da676ed4f732c58824a4886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e56ba66327ff4fc59b01e88c0dc9296d3e98d93fb128be8c4591977d3025e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1e0ea398ff2f5966246b5c34481ce9e94e986df21077f28fbd0a8ee38dfaef8"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"mac-cleanup")
  end

  test do
    # mac-cleanup-go is a TUI application
    assert_match version.to_s, shell_output("#{bin}/mac-cleanup --version")
  end
end
