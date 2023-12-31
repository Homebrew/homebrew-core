class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.7.6.tar.gz"
  sha256 "e1c524fc4f4bd2b0d39df51679d9d065bb811e381b7e4e51466ba39a0083e3ed"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7967c0bbedbc95f1735bc230669702120f18c73bf5de79cc16c6764cd8a9e902"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7967c0bbedbc95f1735bc230669702120f18c73bf5de79cc16c6764cd8a9e902"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7967c0bbedbc95f1735bc230669702120f18c73bf5de79cc16c6764cd8a9e902"
    sha256 cellar: :any_skip_relocation, sonoma:         "665e5ae5d0fc92fae832390f81e2e42e7513b02c6212523d9a1471544da47996"
    sha256 cellar: :any_skip_relocation, ventura:        "665e5ae5d0fc92fae832390f81e2e42e7513b02c6212523d9a1471544da47996"
    sha256 cellar: :any_skip_relocation, monterey:       "665e5ae5d0fc92fae832390f81e2e42e7513b02c6212523d9a1471544da47996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25d4aa1d7bb743e60cff81a9e4ed100432657984d2f459729800459b2aed6832"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.3.5.tar.gz"
    sha256 "41188931a3346787f9f4bc9b0f57db1ba59ab228113dcf0c91382e40960ee783"
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
