class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "5c2e95ad9e688a18dd9d9099c8c132331e01e0bebd401183e8d9123372cf4fcc"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f353c4a51e6558d37aee6976236d67ac90ab7ff8b3057ad9b9593322256b528f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c9fe7900fa5ffba8cec3ad75c0165515bd240503fc00a4c02fcab2afe9020d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c9fe7900fa5ffba8cec3ad75c0165515bd240503fc00a4c02fcab2afe9020d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c9fe7900fa5ffba8cec3ad75c0165515bd240503fc00a4c02fcab2afe9020d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4882f5cd1bdc8ab668286343e4df96d71f523066c8bc5213e7b6c622d07ff7b"
    sha256 cellar: :any_skip_relocation, ventura:        "b4882f5cd1bdc8ab668286343e4df96d71f523066c8bc5213e7b6c622d07ff7b"
    sha256 cellar: :any_skip_relocation, monterey:       "b4882f5cd1bdc8ab668286343e4df96d71f523066c8bc5213e7b6c622d07ff7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c6d89de5982935cf14744372727a79311dea0d62d54575585e0d56d93e67c91"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.4.2.tar.gz"
    sha256 "02e685227fdddd2756993ca019cbe120da61833df070ccf23f250c122c13d554"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end

    generate_completions_from_executable("go", "run", "cmd/caddy/main.go", "completion")

    system bin/"caddy", "manpage", "--directory", buildpath/"man"

    man8.install Dir[buildpath/"man/*.8"]
  end

  def caveats
    <<~EOS
      When running the provided service, caddy's data dir will be set as
        `#{HOMEBREW_PREFIX}/var/lib`
        instead of the default location found at https://caddyserver.com/docs/conventions#data-directory
    EOS
  end

  service do
    run [opt_bin/"caddy", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/caddy.log"
    log_path var/"log/caddy.log"
    environment_variables XDG_DATA_HOME: "#{HOMEBREW_PREFIX}/var/lib"
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
