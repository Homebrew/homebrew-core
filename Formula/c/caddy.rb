class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "de751e6b7ca769f0dc1f9b0a1949c7b149c115efde3aaf53182da2bf6a94c825"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "155d5d2dc956208de5c2493ed58e3813fa06005a5a5b84c69da98c531d998336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "155d5d2dc956208de5c2493ed58e3813fa06005a5a5b84c69da98c531d998336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "155d5d2dc956208de5c2493ed58e3813fa06005a5a5b84c69da98c531d998336"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6c53b0eb4f944bca82094cc93750d9d7317ebbf73d8eefae22919277b78b5fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96290352448bf0a300cb2499ceff406b29266db24f0400bbe91c4355149146da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81dc7c9a7b4fde37f21d3896d3360a3f6387bd1ed513bbf9af6f2357f03321ae"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.4.5.tar.gz"
    sha256 "53c6a9e29965aaf19210ac6470935537040e782101057a199098feb33c2674f8"
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
    environment_variables(
      XDG_DATA_HOME: "#{HOMEBREW_PREFIX}/var/lib",
      HOME:          "#{HOMEBREW_PREFIX}/var/lib",
    )
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
