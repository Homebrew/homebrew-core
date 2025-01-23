class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "beb52478dfb34ad29407003520d94ee0baccbf210d1af72cebf430d6d7dd7b63"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36487e2468a464bd4810d86c4323d1107a6d374f573b43ea07d2b9abf4a6998a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36487e2468a464bd4810d86c4323d1107a6d374f573b43ea07d2b9abf4a6998a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36487e2468a464bd4810d86c4323d1107a6d374f573b43ea07d2b9abf4a6998a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7372c7baf68a2da18554d74f44c3f386a441c115c782f89fa1107a9d44a87598"
    sha256 cellar: :any_skip_relocation, ventura:       "7372c7baf68a2da18554d74f44c3f386a441c115c782f89fa1107a9d44a87598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff8317e8eb4749f085266a92ca5b3d7e6a0b6df45ea257744dbcba8a4842f19"
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
