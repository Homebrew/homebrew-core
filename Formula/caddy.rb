class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.6.2.tar.gz"
  sha256 "563d027a78919f859188fb894ae5f3669508a3430db347aa726cd73c19fb7038"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dd83e404253d26b7a144a91dd4c2c655b4a93960c9c9ec032164b2ce5f4d3ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dd83e404253d26b7a144a91dd4c2c655b4a93960c9c9ec032164b2ce5f4d3ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dd83e404253d26b7a144a91dd4c2c655b4a93960c9c9ec032164b2ce5f4d3ba"
    sha256 cellar: :any_skip_relocation, ventura:        "e38bd54959523aa18ac168f2666a770600c9a08063dd310a3dbd30117f653b99"
    sha256 cellar: :any_skip_relocation, monterey:       "b5db400ed524ee0defc68bc17e3976b7511083f41f5877fc6b6b6223601f8f0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5db400ed524ee0defc68bc17e3976b7511083f41f5877fc6b6b6223601f8f0d"
    sha256 cellar: :any_skip_relocation, catalina:       "b5db400ed524ee0defc68bc17e3976b7511083f41f5877fc6b6b6223601f8f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf3c87e24fa4b0ad663ebb06c665d43c1d06eabc51cf89a33439c51ec38ed2b2"
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
