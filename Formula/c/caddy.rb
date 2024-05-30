class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "1efd6aad92210288a89b76c1e639da7ba0009f2ab3ae7c78b5818b67257f732c"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b48b3ea84b1800c343a7e8ea76fe9a4874d6d41fefe1856a1ed79618fe70824d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b48b3ea84b1800c343a7e8ea76fe9a4874d6d41fefe1856a1ed79618fe70824d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b48b3ea84b1800c343a7e8ea76fe9a4874d6d41fefe1856a1ed79618fe70824d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dab6c258cb899ea97f0170ebdbd30cd40b3c26e230fa6ce8934a9618429223fd"
    sha256 cellar: :any_skip_relocation, ventura:        "dab6c258cb899ea97f0170ebdbd30cd40b3c26e230fa6ce8934a9618429223fd"
    sha256 cellar: :any_skip_relocation, monterey:       "dab6c258cb899ea97f0170ebdbd30cd40b3c26e230fa6ce8934a9618429223fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a44d27e42dc2f39de5b8a53700f10faf354c3967e3b03c47a664a4b7fce3bf3"
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
