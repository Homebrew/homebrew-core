class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.91.0.tar.gz"
  sha256 "ff30bbe43733f2a7e01b0b99bab4eda9e38e19c67125f04bf5b9ffe9600c777c"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71cb1d1134000e0aa77a900d4370e55463f1c17e12750aa0d08d973ed979a497"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "469691a17f71e81300809ae9853d31e3ef8a63f762441ad619e2c4f3eaee7642"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b7f7cff607a3f909f9e28c068c562bae73a9598ef8554dbc24ec65c40e15860"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a8a3509225ccfa442f9632df818a1c0e68b6d254acd9a6a3923b3b69f05b531"
    sha256 cellar: :any,                 x86_64_linux:      "5cd40a3ee7af7380cf7753e8da03931bbcefede76d7e83776f61202621b9fc96"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "web", "fetch"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "web", "install", "--frozen-lockfile"
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
