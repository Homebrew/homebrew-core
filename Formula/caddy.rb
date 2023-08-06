class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.7.3.tar.gz"
  sha256 "ff73a9bd9968d63cae3d9f804d83e67759836a5331c9b13d04b30ebe86369722"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a852d5aabcb0f6a60d2aa3c5641b864e0b78ff5d89b5175f82fbd8e43f2630"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a852d5aabcb0f6a60d2aa3c5641b864e0b78ff5d89b5175f82fbd8e43f2630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7a852d5aabcb0f6a60d2aa3c5641b864e0b78ff5d89b5175f82fbd8e43f2630"
    sha256 cellar: :any_skip_relocation, ventura:        "9c3b5b60079561b444b1efbccd333ccbc6d8148bc794c3cf9e58a4c174ef4d27"
    sha256 cellar: :any_skip_relocation, monterey:       "9c3b5b60079561b444b1efbccd333ccbc6d8148bc794c3cf9e58a4c174ef4d27"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c3b5b60079561b444b1efbccd333ccbc6d8148bc794c3cf9e58a4c174ef4d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c52cea2c18ab78666f7fc07f125277f27e1e93c7353f03e5e4a2af0f6e21712"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/refs/tags/v0.3.4.tar.gz"
    sha256 "5ff7b73c2601ceaf3fd1b3d92be49244523b9b98ee6127276d54c4df59a73d28"
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
