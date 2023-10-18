class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.7.5.tar.gz"
  sha256 "eeaecc1ea18b7aa37ece168562beb1ab592767cbedfaa411040ae0301aaeeef1"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7f37dc97d2b098fb2e8af0f8abfa0f14625a96d1932b7ec90a51bea1fcd583b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7f37dc97d2b098fb2e8af0f8abfa0f14625a96d1932b7ec90a51bea1fcd583b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7f37dc97d2b098fb2e8af0f8abfa0f14625a96d1932b7ec90a51bea1fcd583b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a605d80248baeba536a2689699ca5d4bac468e96209fad67dc9818085f74f574"
    sha256 cellar: :any_skip_relocation, ventura:        "a605d80248baeba536a2689699ca5d4bac468e96209fad67dc9818085f74f574"
    sha256 cellar: :any_skip_relocation, monterey:       "a605d80248baeba536a2689699ca5d4bac468e96209fad67dc9818085f74f574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1fff754967a19cb33229ae860487cf27633e1dde8c74325a3b9f9658dce47ef"
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
