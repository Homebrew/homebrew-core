class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "bba49fc32b4d0f54335ef240fc28200c460707e482ff3d6003af2fb598103363"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e88695094f8d119142413ec21621c88c3d061f0433e9169b34aa16968929c5f8"
    sha256 cellar: :any,                 arm64_sequoia: "3fa60aa1fd5e79b21c09047f79615462456eee7214dd74f4dc742df3e21d2ab7"
    sha256 cellar: :any,                 arm64_sonoma:  "0d5b7462e54f716013b8bf4ed617fda6b4c635cfbbcb0e4223ecbf412f48f551"
    sha256 cellar: :any,                 sonoma:        "de145c8bd45f1a9cdae5979a557897fb6184d40b6b0df2585e7ce71fe1bb3eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43706c1a39440a3f9b71825e137f4380590c58d599a2332b3b49bc20d8a0857b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd33054e303eef7fb02644fb9115ac04494633dabbf688f0b4460ee27ad9a17e"
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
