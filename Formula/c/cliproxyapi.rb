class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.76.tar.gz"
  sha256 "d40224c4239bd6b9417c902079fe69c9a923c227bdc7ca41fe31414bf41329b1"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "d61190efdb17079533509e450744a94ae065a746ef24faf8329e903190b2823f"
    sha256 arm64_tahoe:       "9c0955c5755b0135b05e0d83ad94efe5b9ec9a47a638894f363d1e1df2397dcc"
    sha256 arm64_sequoia:     "c887166c3805f5dd5a09cc15d30673b3cbb4feed4d6609624b8efb3fe5cc42f5"
    sha256 arm64_linux:       "4fdd2df9b2ac16684277c5374765b8381efb66b979385ec21a39ba87b0e1584d"
    sha256 x86_64_linux:      "e182044a7bb13e50e21fa70e2e91faf4470048a8480eda4151108ffa3db032b6"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
