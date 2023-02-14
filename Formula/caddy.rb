class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.6.4.tar.gz"
  sha256 "41f26a7e494eb0e33cd1f167b3f00a4d9030b2f9d29f673a1837dde7bb5e82b0"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d26a4ed059d1d14369345222721116ab49b1366caf464576a6914adb62de8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f22bb76cc1a52e4d71efe87c97b2472dada491a6bda2ed4f887342115e3d02cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49cba0d2e27a6910908dd145082da3531c94e36e9ebc49f16b5aec236cc84019"
    sha256 cellar: :any_skip_relocation, ventura:        "9e0f2b75421530fe58c6b1e027440a137a5ec841f9fec368f148b234761094aa"
    sha256 cellar: :any_skip_relocation, monterey:       "194e116902cc1c1b8929c2bfe7844bc7ee79205b6fc4d027a62f40abb943581c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dda98dca64e988bf9b237fb89122034f5e38cbc637f8dfc3e00928902c6f5a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda1f43357bdb2294304cd1dc5edf0b7a1f71fb48364a2165f31fa1f34387e8b"
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
