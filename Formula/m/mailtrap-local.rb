class MailtrapLocal < Formula
  desc "Local email sandbox with SMTP server, web UI, and JSON API"
  homepage "https://github.com/mailtrap/mailtrap-local"
  url "https://github.com/mailtrap/mailtrap-local/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "af6b3143466e71c12ba5bd0393d03cd45143de63cb350dbe8c4b77bb14743484"
  license "MIT"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    rm_r "cmd/mailtrap-local/dist"
    cp_r "frontend/dist", "cmd/mailtrap-local/dist"
    cp "docs/api/openapi.yaml", "cmd/mailtrap-local/openapi.yaml"

    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/mailtrap-local"

    bin.install_symlink "mailtrap-local" => "mailtrap-sendmail"
  end

  service do
    run [
      opt_bin/"mailtrap-local",
      "--http-listen", "127.0.0.1:3550",
      "--smtp-listen", "127.0.0.1:3535",
      "--db", "#{var}/mailtrap-local/db.sqlite3"
    ]
    keep_alive true
    log_path var/"log/mailtrap-local.log"
    error_log_path var/"log/mailtrap-local.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mailtrap-local --version")

    http_port = free_port
    smtp_port = free_port

    spawn bin/"mailtrap-local",
          "--http-listen", "127.0.0.1:#{http_port}",
          "--smtp-listen", "127.0.0.1:#{smtp_port}",
          "--db", testpath/"mailtrap-local.sqlite3"

    sleep 2

    output = shell_output(
      "curl -s http://127.0.0.1:#{http_port}/api/v1/openapi.yaml",
    )
    assert_match "openapi:", output
  end
end
