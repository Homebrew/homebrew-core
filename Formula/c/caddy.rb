class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/refs/tags/v2.7.6.tar.gz"
  sha256 "e1c524fc4f4bd2b0d39df51679d9d065bb811e381b7e4e51466ba39a0083e3ed"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80d0683f58a41ead917ffd0d3c83471d3cb5e6bfa6699fb248a29b958569520a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80d0683f58a41ead917ffd0d3c83471d3cb5e6bfa6699fb248a29b958569520a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80d0683f58a41ead917ffd0d3c83471d3cb5e6bfa6699fb248a29b958569520a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a72f5f77bcbc300ca82ab60a868cbf8dbcbaf3a0eb4e7d22a4d7190f773245ac"
    sha256 cellar: :any_skip_relocation, ventura:        "a72f5f77bcbc300ca82ab60a868cbf8dbcbaf3a0eb4e7d22a4d7190f773245ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a72f5f77bcbc300ca82ab60a868cbf8dbcbaf3a0eb4e7d22a4d7190f773245ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a7af2c32ee507d80ce4a70a0e4ef8281a2601ed2da8e42c0dc1838e491d163e"
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
