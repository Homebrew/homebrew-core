class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.4.3.tar.gz"
  sha256 "10317b5ab7bee861631a8d94d13aeafb62e9665759271a6c65422a70d6584d6b"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3c3e8b95721eb7562d11326d8cfbff6cada1a318f71ca7e181ec55e6f356a05"
    sha256 cellar: :any_skip_relocation, big_sur:       "e40f7566a45c4342ab7d27906c856ef28ead44ee5926b037df8f38a8ec7b5db8"
    sha256 cellar: :any_skip_relocation, catalina:      "e40f7566a45c4342ab7d27906c856ef28ead44ee5926b037df8f38a8ec7b5db8"
    sha256 cellar: :any_skip_relocation, mojave:        "e40f7566a45c4342ab7d27906c856ef28ead44ee5926b037df8f38a8ec7b5db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "041f6bbbd340bf60b486c23f5836019f89413a2f47f04a640cb7be9a2e84655b"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.1.9.tar.gz"
    sha256 "399880f59bf093394088cf2d802b19e666377aea563b7ada5001624c489b62c9"
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
