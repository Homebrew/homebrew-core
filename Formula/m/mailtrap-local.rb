class MailtrapLocal < Formula
  desc "Local email sandbox with SMTP server, web UI, and JSON API"
  homepage "https://github.com/mailtrap/mailtrap-local"
  url "https://github.com/mailtrap/mailtrap-local/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "91d30439b3420d72939900d604e0a232504f1fca77546d46cae2b8ca77e7bba6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba85219d26b703da8a390e8359f2af3db9b493faef7fd4711a2978a85748e1f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba85219d26b703da8a390e8359f2af3db9b493faef7fd4711a2978a85748e1f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba85219d26b703da8a390e8359f2af3db9b493faef7fd4711a2978a85748e1f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7cea686d340f7d4655228ca772454c7aed15a90177519ee8df92485ea413fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fd396a91876c0ef6cdf53ca2dba0405efe360313016a39bfaed461abefe44a7d"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    rm_r "cmd/mailtrap-local/dist"
    mv "frontend/dist", "cmd/mailtrap-local/dist"

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/mailtrap-local"
    bin.install_symlink "mailtrap-local" => "mailtrap-sendmail"
  end

  service do
    run [opt_bin/"mailtrap-local", "--db", var/"mailtrap-local/db.sqlite3"]
    keep_alive true
    log_path var/"log/mailtrap-local.log"
    error_log_path var/"log/mailtrap-local.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mailtrap-local --version")

    http_port = free_port
    smtp_port = free_port
    pid = spawn bin/"mailtrap-local", "--http-listen", "127.0.0.1:#{http_port}",
                                      "--smtp-listen", "127.0.0.1:#{smtp_port}",
                                      "--db", testpath/"mailtrap-local.sqlite3"
    begin
      api = "http://127.0.0.1:#{http_port}/api/v1"
      assert_match "openapi:", shell_output("curl -s --retry 10 --retry-connrefused #{api}/openapi.yaml")

      ENV["MAILTRAP_LOCAL_SMTP_ADDR"] = "127.0.0.1:#{smtp_port}"
      pipe_output("#{bin}/mailtrap-sendmail -t", <<~EOS, 0)
        From: brew@example.com
        To: test@example.com
        Subject: Homebrew test

        Hello from Homebrew
      EOS
      assert_match "Homebrew test", shell_output("curl -s #{api}/messages")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
