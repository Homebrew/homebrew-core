class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "f63f46b7ae68ced0a5c2e31df1b6dfc7656117d162a1bc7fed4bd4afd14ddc8f"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcbd54fcb23ed8c2be5bb2e1b23442931e798ede2ed7e8227cfb148f28925dc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1df2298f7b51056b57eef3a304d2807652d5c630d884de5560b271e5942e50e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1df2298f7b51056b57eef3a304d2807652d5c630d884de5560b271e5942e50e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1df2298f7b51056b57eef3a304d2807652d5c630d884de5560b271e5942e50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eaf6b2c9831bbb7cac75b4b536625434d6bedd344ed6caaf2f916c34cb91016"
    sha256 cellar: :any_skip_relocation, ventura:       "2eaf6b2c9831bbb7cac75b4b536625434d6bedd344ed6caaf2f916c34cb91016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29d001f80337e2bfcf0dc979b0a56953528df9f1ce3605fe18e3a6e506291182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529b5fc2dbf675f8440f68f83a56b39d804d08eb48a59c546764612e2fd93a52"
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
