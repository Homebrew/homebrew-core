class Ladder < Formula
  desc "Selfhosted alternative to 12ft.io and 1ft.io HTTP web proxies"
  homepage "https://github.com/everywall/ladder"
  url "https://github.com/everywall/ladder/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "e837284c3e283d7de1441b55606bd54ecc10bb6c81abed5a96b9e6836d7d3a2a"
  license "GPL-3.0-only"
  head "https://github.com/everywall/ladder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b302abc9ec720bedd6b845063ffcb0224e960db49fb75662ec5bacaf072f54cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b302abc9ec720bedd6b845063ffcb0224e960db49fb75662ec5bacaf072f54cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b302abc9ec720bedd6b845063ffcb0224e960db49fb75662ec5bacaf072f54cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b63a6472eaf9eddc3eb6f0cc523a361a53857c698c06be63d717fa0f4a69b38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033971f9648f26fcc48b120ac9e74ec49543948840ac0e701dc3e5dde3390541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca5d954759aa059b8f73a53ecf583beaee329c0038036af2fe0058a9b6c09fa1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/main.go"
  end

  test do
    port = free_port
    pid = spawn bin/"ladder", "-p", port.to_s
    sleep 2

    output = shell_output("curl -s http://127.0.0.1:#{port}/")
    assert_match "ladder", output
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
