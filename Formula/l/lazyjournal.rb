class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.8.3.tar.gz"
  sha256 "0e8525060eb63dc49f1dd254e742b8e68cf8a18f966440dd5e0b8d01dc1e55f8"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33515fa417b33688f50db52fe8eb3df795f2887c391f3eee6e51df5cd09c0389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33515fa417b33688f50db52fe8eb3df795f2887c391f3eee6e51df5cd09c0389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33515fa417b33688f50db52fe8eb3df795f2887c391f3eee6e51df5cd09c0389"
    sha256 cellar: :any_skip_relocation, sonoma:        "75794090fdb452b5c362b45dc22b4589f6d7abf0708ffcf05c7ef43b3ca0db6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93e6efba050a3a3c319bf49219460ce420786f0f6f66b2aacb6daa0f8f65a2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abca5a9f72ee87d3518ca75b44cc4ceb1e598454751a5bee6ea32e6586ecbd95"
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
