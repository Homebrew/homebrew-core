class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.6.0.tar.gz"
  sha256 "8c605e6fcfc5424e67d93ece10ff0e9cd9cc9f0c2cbad71d17143f8d0593402d"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "978bebfb0eabf7f1382aa51233e2d1533a14ddce55a81bfa3638bc64c66a72e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "978bebfb0eabf7f1382aa51233e2d1533a14ddce55a81bfa3638bc64c66a72e2"
    sha256 cellar: :any_skip_relocation, monterey:       "bf9c5c9b0db8920053ddbc5a3002afb9bfb3fbe46f2e91a614e6d1ef71d6a587"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf9c5c9b0db8920053ddbc5a3002afb9bfb3fbe46f2e91a614e6d1ef71d6a587"
    sha256 cellar: :any_skip_relocation, catalina:       "bf9c5c9b0db8920053ddbc5a3002afb9bfb3fbe46f2e91a614e6d1ef71d6a587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf0f9f4691126b5808d4c51c870fa80d24c1478aecb2ae6369966f0dad1855d"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.3.1.tar.gz"
    sha256 "b99d989590724deac893859002c3fc573fb66b3606c1012c425ae563d0971440"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end

    generate_completions_from_executable("go", "run", "cmd/caddy/main.go", "completion")
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
