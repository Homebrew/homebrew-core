class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.6.1.tar.gz"
  sha256 "ae698b4618dc6ffe7370b0607d59ee78833cb4986ca5663c50a9ae0b90072ac1"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e50cce1ca01a9f58882d9fca037a243705786ffddb61a61a1c90867ce512ecf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e50cce1ca01a9f58882d9fca037a243705786ffddb61a61a1c90867ce512ecf"
    sha256 cellar: :any_skip_relocation, monterey:       "35d694db0a3a53a3b0426911ae2438edb29f7bff97e249e83df075c5f7a2dc80"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d694db0a3a53a3b0426911ae2438edb29f7bff97e249e83df075c5f7a2dc80"
    sha256 cellar: :any_skip_relocation, catalina:       "35d694db0a3a53a3b0426911ae2438edb29f7bff97e249e83df075c5f7a2dc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5648a8f05d7ed4974e346d7c38020e7d1007025ad30cc0ce17319bf3d3dd98f"
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
