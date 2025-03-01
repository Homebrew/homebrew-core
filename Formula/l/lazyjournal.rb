class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.7.4.tar.gz"
  sha256 "0e7e6b15efa2163ea27e454da1e90d87a55096c56581d94c76429670f04064d8"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.buildSource=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjournal --version")
  end
end
