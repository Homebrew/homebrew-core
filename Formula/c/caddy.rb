class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.7.4.tar.gz"
  sha256 "97f687c1d9fbe275952cc932639e8f0ab90cb7177961b02078fba989b4e29c31"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb04f62697fc6927906e2cf9f2244b5b48ab46263da870cf8226e5e53c439ded"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4f2e19e042547c669a8ea082922eea5f63c03ab9637c5d27e49e81f72f71a0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f2e19e042547c669a8ea082922eea5f63c03ab9637c5d27e49e81f72f71a0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4f2e19e042547c669a8ea082922eea5f63c03ab9637c5d27e49e81f72f71a0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c458258202cd0be547aa509d2bf0d093e71f37832901ef1d93370ce9b076dfd"
    sha256 cellar: :any_skip_relocation, ventura:        "92cee727d96126a084d5cb797f449a807b8c40ed70d435a3729a3444ea72b6a4"
    sha256 cellar: :any_skip_relocation, monterey:       "92cee727d96126a084d5cb797f449a807b8c40ed70d435a3729a3444ea72b6a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "92cee727d96126a084d5cb797f449a807b8c40ed70d435a3729a3444ea72b6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58c7d710892c33d3083ef4c60f8f233759b7efd1ce8dbeeb6b02de0d8c22f642"
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
