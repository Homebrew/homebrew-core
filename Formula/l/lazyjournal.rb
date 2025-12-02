class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.8.2.tar.gz"
  sha256 "5fb748c05ea9feb2fb957dfcac79db8b80a27afc1733b0ca3fc58046ad3e96eb"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80de754269008b91628d40cc8e4af09c40761b067faea561303e07b0d1d79847"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80de754269008b91628d40cc8e4af09c40761b067faea561303e07b0d1d79847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80de754269008b91628d40cc8e4af09c40761b067faea561303e07b0d1d79847"
    sha256 cellar: :any_skip_relocation, sonoma:        "831b48d70f6ccccf8e897ec555f5c51a8a434b030ea2257967820ecc25be53ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be4366f5155fa242c3fe7355950a438ea38dcf02dc6b1b2cb48c39a36dd4c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b202cb319d416f2de20efb753f836de055c68aa7e255afdf7acc3592015d2da9"
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
