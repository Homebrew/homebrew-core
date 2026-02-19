class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.8.5.tar.gz"
  sha256 "2cfc8aa53c195a1ad7b7a6c3f9b17652eac4c24863d8c1079e61acf9497819c1"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bde455e98f3fe65e534813a5ed7bf17a0063083e970e1f44ef40a8ac62acdb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bde455e98f3fe65e534813a5ed7bf17a0063083e970e1f44ef40a8ac62acdb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bde455e98f3fe65e534813a5ed7bf17a0063083e970e1f44ef40a8ac62acdb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e0ae947a159934998b1440161ddb4ac72f3faf78566bb2c7e3eec28eeb9e58f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30fea8709af118108b6f233e3fbcee3b6909bb045ec73825362af2a73ba645e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555196fa2e59b70b597c09329b6a123bdcb60f544603eee363b7df53be4d783a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
