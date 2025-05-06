class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.7.8.tar.gz"
  sha256 "64b23ee8a4d2c0588f0ffc372f8aa0a4841cc9bc2ec7b5d6a4cd0603b4feb687"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b92cbb1579960d97d75b36935f47b688423ec630b434524b01e34767bafd54d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b92cbb1579960d97d75b36935f47b688423ec630b434524b01e34767bafd54d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b92cbb1579960d97d75b36935f47b688423ec630b434524b01e34767bafd54d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "abf19ab18b8b575c78a4d8842d05eae04be71183046e929088faa0f9f2f7ae27"
    sha256 cellar: :any_skip_relocation, ventura:       "abf19ab18b8b575c78a4d8842d05eae04be71183046e929088faa0f9f2f7ae27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac6108176eb6a1339d7415547394ec4fb46f8e60e73205bf85654ed2757f493"
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
