class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.11.7.tar.gz"
  sha256 "86e39de5fa0bc433a9cd574a00e7751059903401f3389c61f8937fd0ad0180f5"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7afb55ae0f5a46a9d76a8278ef999a8f7abc8fdf7fe55b7dae615af5de1ab5b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7afb55ae0f5a46a9d76a8278ef999a8f7abc8fdf7fe55b7dae615af5de1ab5b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7afb55ae0f5a46a9d76a8278ef999a8f7abc8fdf7fe55b7dae615af5de1ab5b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58964220f1b630583efd669d7181a7691d962ab8ee3c33c7c1025085534a2660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4b2f7b09cead0281082a9cc84fcd0a118f33fab46409a3ad6a9ac921b8d2f1ea"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.4.5.tar.gz"
    sha256 "53c6a9e29965aaf19210ac6470935537040e782101057a199098feb33c2674f8"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    # caddy's own modules, for the `go run cmd/caddy/main.go` completions step
    # and as the dependencies of the tagged caddy module xcaddy builds
    system "go", "mod", "download", "all"
    # the tagged caddy module itself, resolved by xcaddy at build time
    system "go", "mod", "download", "github.com/caddyserver/caddy/v2@v#{version}" unless build.head?
    # xcaddy's own modules
    resource("xcaddy").stage do
      system "go", "mod", "download"
    end
  end

  def install
    # modules were downloaded and sumdb-verified in `fetch`; the temp module
    # xcaddy creates has no go.sum, so serve it from the local cache only
    ENV["GOPROXY"] = "off"
    ENV["GOSUMDB"] = "off"

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
