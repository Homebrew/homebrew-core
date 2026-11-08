class OtelTui < Formula
  desc "Terminal OpenTelemetry viewer"
  homepage "https://github.com/ymtdzzz/otel-tui"
  url "https://github.com/ymtdzzz/otel-tui/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "fc8a5ab4416b9428532978cb759b31f83bc27e8617e44545c53fb41d401a3d91"
  license "Apache-2.0"
  head "https://github.com/ymtdzzz/otel-tui.git", branch: "main"

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
