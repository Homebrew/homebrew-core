class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "97fda65127c6d0754b6dd990df40ba0cc4a2a0064a6c460f59e5a9f83f72293c"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "759b7f3592d2aa32275de1003bbb17a60113d7af4f594e5909ef5bee5ee928d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70e9bff4c4cb0f7182417a7c3ebc04a20bafc45660cacaf00ca65d0dfc99d056"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93903c566aacdc19ec60642795a4ee0aaa67496c58bfaf2f94b69d369eb65e13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "63b8cdd06076b6e1923dd73b88e609144eafaff0c5e91b5a9695d4cf516cdfc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "829ddd903b89c4b9ee617caa9cf500a7962e7e79a9cd7d0d1ff2f02ca1fc3f21"
    sha256 cellar: :any,                 x86_64_linux:      "3cd57dc2f9a676bc3afc9a46604e320a7ac5febecc6303119e5005a0cab59bff"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "web", "install"
    system "pnpm", "with", "current", "--dir", "web", "run", "build"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags: :goreleaser), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags: :goreleaser), "./cmd/autobrrctl"

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

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

    pid = spawn bin/"autobrr", "--config", testpath/""
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
