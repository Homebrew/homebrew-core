class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.6.4.tar.gz"
  sha256 "41f26a7e494eb0e33cd1f167b3f00a4d9030b2f9d29f673a1837dde7bb5e82b0"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d7d39c42ab031511e899469a442c31eb525388b6d11583ea20bd25494fb2b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7d39c42ab031511e899469a442c31eb525388b6d11583ea20bd25494fb2b67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d7d39c42ab031511e899469a442c31eb525388b6d11583ea20bd25494fb2b67"
    sha256 cellar: :any_skip_relocation, ventura:        "495147632d0fa351302489a9e84765dcba5169119a25529dbf475c97ab54bfc0"
    sha256 cellar: :any_skip_relocation, monterey:       "495147632d0fa351302489a9e84765dcba5169119a25529dbf475c97ab54bfc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "495147632d0fa351302489a9e84765dcba5169119a25529dbf475c97ab54bfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb6f17b4da836218574f3e6d4f6e9be3686831d50daccf68503069e4e14cc7c8"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.3.2.tar.gz"
    sha256 "7b846312d1cd692087c9f044d88ba77be2e5a48aca6df9925757b60841c39c69"
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
