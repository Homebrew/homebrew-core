class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.4.5.tar.gz"
  sha256 "f25a24dfd6398e02ed3e530621f800eb7c7496d302d0a86b6932c219e46320cd"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "978286796a9e06f3bbaf65ceebeb2ec435756c20f9b1826945207a8539bdd321"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e0a42061349cbaa0e7c8ebc1999868772f4cde71162c95220c9c202f2f1f932"
    sha256 cellar: :any_skip_relocation, catalina:      "3e0a42061349cbaa0e7c8ebc1999868772f4cde71162c95220c9c202f2f1f932"
    sha256 cellar: :any_skip_relocation, mojave:        "3e0a42061349cbaa0e7c8ebc1999868772f4cde71162c95220c9c202f2f1f932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559278f9a8219596855c856c8db58e8289c66940e52fcea7ce5b023e0f96400f"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.2.0.tar.gz"
    sha256 "20e4994cc52323f8420741efafa78b8d29b1ad600e59671287436e236c2c3be2"
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
