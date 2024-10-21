class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "0f5e59e82589335d7961767bd1f74b65567b1544719a79eb50ec7dffbdc06239"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c2e8f19c231f1fca7057b447c33370362f299fe8c0f0b6119cccc98d472f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16c2e8f19c231f1fca7057b447c33370362f299fe8c0f0b6119cccc98d472f7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16c2e8f19c231f1fca7057b447c33370362f299fe8c0f0b6119cccc98d472f7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52a6561d8506c2cbf9db943759e7b73d1ea75905525de86ceb8b311f46c54ebe"
    sha256 cellar: :any_skip_relocation, ventura:       "52a6561d8506c2cbf9db943759e7b73d1ea75905525de86ceb8b311f46c54ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bce4e9de20c7306c9098baa7ba3ed59764bc7cee746a6cfbb49d5c6bc5ff8da"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"
  end

  def post_install
    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec bin/"autobrr", "--config", "#{testpath}/"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
