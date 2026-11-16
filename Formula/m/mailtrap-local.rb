class MailtrapLocal < Formula
  desc "Local email sandbox with SMTP server, web UI, and JSON API"
  homepage "https://github.com/mailtrap/mailtrap-local"
  url "https://github.com/mailtrap/mailtrap-local/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "15fc6a2ef722fd3d97bebd36dee91d72ea2c9e2d54b04f580d276c0ae15ebe90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9ae0b039b8950dbf5d61e44f79bf1bfd78aa22c1864e41862bef246b6cb6630"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9ae0b039b8950dbf5d61e44f79bf1bfd78aa22c1864e41862bef246b6cb6630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9ae0b039b8950dbf5d61e44f79bf1bfd78aa22c1864e41862bef246b6cb6630"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "050bdbe4c30606ab1e90676db169c9fda1ca4c2dc3379eefdc09ccb4174f90e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "674f603bca3dcdf733b2a4295ce554df22cca612f25247a47387bba4d7ea00c7"
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
