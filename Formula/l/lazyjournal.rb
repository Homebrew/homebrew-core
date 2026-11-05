class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.8.7.tar.gz"
  sha256 "9db27ffb8f6f407bbb618ca598e876998a3f3b50b6ca18bc12b8adcfa46821e4"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4365fb59a59ca1f164f0215b21f2e109391a15f35e03cdf8ef26352cc0f74aee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4365fb59a59ca1f164f0215b21f2e109391a15f35e03cdf8ef26352cc0f74aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4365fb59a59ca1f164f0215b21f2e109391a15f35e03cdf8ef26352cc0f74aee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dbbf72aa6f151435b2d4d2910e089db72e250009734f9c986d4d7e43a29b3257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d6fe8c9f15f435d270125e4ee021e4706080bc606efa7c74a3fccc076a716ebb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
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
