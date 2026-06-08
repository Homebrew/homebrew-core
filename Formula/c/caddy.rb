class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "2c3d02078286a6282cdb4d1d8744077788d556659dac0b64d8ed5886a7e5aeb9"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e9aa3be3d01ea8128bd16cdb0de0b274da276dba4882addedd43b8748ad94d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e9aa3be3d01ea8128bd16cdb0de0b274da276dba4882addedd43b8748ad94d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9aa3be3d01ea8128bd16cdb0de0b274da276dba4882addedd43b8748ad94d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "27b2aa14d92c02c159a265f1604240cfd55963e6ba5563b7ccac752937624859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e586256f93f81b80de38b8bce008cbaf788f925b81e6aedecf98c7d3612385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccfdb7ee4df4bbcbcba207c4a7009fc7d5859435df1277c784421b67d7127639"
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
