class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "e07e2747c394a6549751950ec8f7457ed346496f131ee38538ae39cf89ebcc68"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a0def155db07e2c3212e3c290b9a675e38935fdfae37e2dbe71f0e0238f5ab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a0def155db07e2c3212e3c290b9a675e38935fdfae37e2dbe71f0e0238f5ab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a0def155db07e2c3212e3c290b9a675e38935fdfae37e2dbe71f0e0238f5ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e2e30ad4694c7cb0f9d4066a45cef177c0a36293526b8e61d58d72fbb1284d5"
    sha256 cellar: :any_skip_relocation, ventura:       "7e2e30ad4694c7cb0f9d4066a45cef177c0a36293526b8e61d58d72fbb1284d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edfead41ad5b1c16440cfd7a9bb0a600a58d80ca7bffa23466d2510aba4d20cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4055b37a0e00a1209288f8e49b72632ee97fd2d80ca8aa195731cff4111c90c3"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.4.4.tar.gz"
    sha256 "5ba32eec2388638cebbe1df861ea223c35074528af6a0424f07e436f07adce72"
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
