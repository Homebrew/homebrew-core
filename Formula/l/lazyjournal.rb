class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.7.4.tar.gz"
  sha256 "0e7e6b15efa2163ea27e454da1e90d87a55096c56581d94c76429670f04064d8"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "025c5da08d23eab8dc62b177c8c6b43bf379e80c0413df7861363eb309e7b1cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "025c5da08d23eab8dc62b177c8c6b43bf379e80c0413df7861363eb309e7b1cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "025c5da08d23eab8dc62b177c8c6b43bf379e80c0413df7861363eb309e7b1cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5046800f8cef4d935c5e36cbd1a178865e147aaa87171cc8a860af697c67913e"
    sha256 cellar: :any_skip_relocation, ventura:       "5046800f8cef4d935c5e36cbd1a178865e147aaa87171cc8a860af697c67913e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6de7c2e3c757c2e4e38e63ab33a91815d6bc34aac916c218ad03295cb2653d02"
  end

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

    require "pty"
    PTY.spawn bin/"lazyjournal" do |_r, _w, pid|
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
