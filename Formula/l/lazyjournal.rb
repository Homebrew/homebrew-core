class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.8.1.tar.gz"
  sha256 "62c5d54b3f2bf2ca240d9522ab75320b96f6304cf83b63a2db936411ec52cd64"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ef7ed4bfc7bf612427c0c3a758518a2e036bdaf8fb866570bf718d15b5d8782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef7ed4bfc7bf612427c0c3a758518a2e036bdaf8fb866570bf718d15b5d8782"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef7ed4bfc7bf612427c0c3a758518a2e036bdaf8fb866570bf718d15b5d8782"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4191ac7b32cd392316bc7f1edd179e1c565dd3756b29b66858dc4030290ebe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea92d96e8b123858ae87ee6f2496d6a275de189b51ba2309ad101bc7e3765669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb47b038232ce4c2640bc22a54d893ba91c088ca6c23e2e923b63f485272410e"
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
