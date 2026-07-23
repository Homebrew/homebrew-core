class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "6714696c037b15e87e6aaa112b3f0300f1a8c3af13bffe59fe55ea7d802ec7e1"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ba3c70a0e3291f4616abde50c70c3018459de70ae2d03cbf526ee73a97b37d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7730a538f1ccf72b5ccd7c7d84c2d7f2221fd2bfab03fa3216bf4e80e2888fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "858afd65a62d73646b1d2724d728fd4ea707255c532f7c7228e89b77aea7af85"
    sha256 cellar: :any_skip_relocation, sonoma:        "94169b172d0858ca419cd76a38b6cddf61a0b8afe1e0ab2eb7f1335111da73a7"
    sha256 cellar: :any,                 arm64_linux:   "56665506d05df900a235ccf40cb5a2883b963c199e8763cc0e4898ae34768d9a"
    sha256 cellar: :any,                 x86_64_linux:  "bbd9bb9adf8f917deeaa6a11308c2070ad1396308e1a867e3d9e3b1cdf45629c"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
