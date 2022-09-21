class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.6.0.tar.gz"
  sha256 "8c605e6fcfc5424e67d93ece10ff0e9cd9cc9f0c2cbad71d17143f8d0593402d"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "711c229bf9524a4957a1dea8f7d1a5d4d61876c5065d9227c2c0ac006eee72c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "711c229bf9524a4957a1dea8f7d1a5d4d61876c5065d9227c2c0ac006eee72c6"
    sha256 cellar: :any_skip_relocation, monterey:       "3d482b1c9c2d499bbc79c7515ca91a9a9ba0f58d65b92398c16737e915c7b17a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d482b1c9c2d499bbc79c7515ca91a9a9ba0f58d65b92398c16737e915c7b17a"
    sha256 cellar: :any_skip_relocation, catalina:       "3d482b1c9c2d499bbc79c7515ca91a9a9ba0f58d65b92398c16737e915c7b17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ba5f175de04babccd1ddb4b59c05d98e0c2750c2e5faf7884ef38cc00bcb4db"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.3.0.tar.gz"
    sha256 "1a59ff6f51959072a512002e7ec280ea96775361277ba046a8af5a820a37aacd"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end
  end

  service do
    run [opt_bin/"caddy", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/caddy.log"
    log_path var/"log/caddy.log"
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end
