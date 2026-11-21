class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "91d564e41df6bfa55e666bd2bdb86c459569b41407027599ea5e87b32943cd0a"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

  bottle do
    manifest_sha256 "0c9d72f0c66ec3c44988c134fa07ab95b8551c66004e5e3f928bbd7fc2f36b3a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42ef4b3f3b9baf7f0b18c011ae96198a05175ca6d3b692f3c40050e1285c17c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4bcb1199f3503f0798df30f98e90f1ba0835be409b993cafff7b00bbe0f0c4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8fcbe3ff37a44d07d479261b4f8f3c672265cd917011247d00b6d67c2631e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "994d88048493c7ed1912afbf04fd08bb00846e5fc576a990897dbdb132392a4c"
    sha256 cellar: :any,                 x86_64_linux:      "85894a272898bd9d27b6d677a8743fe0ed4f396bc64afe70b2bbde1e99ae0404"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    # otel-tui is a TUI application
    assert_match version.to_s, shell_output("#{bin}/otel-tui --version")
  end
end
