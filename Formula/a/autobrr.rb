class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.90.0.tar.gz"
  sha256 "188462dcc05dd3781cd906f79708ffbbba5e058053cc24e27c0cec1059d23c02"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a01d7c9cbeb7690fdee4b4e5d8ddb15864bedde3f55ca9856fe8ce07e49f518d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fbad8f39d7643559bb5311b492f84e876ffd4f1eb6b327ff85b36b201d3300b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd4beef31025a145b2c184593879faed1950f1febcd90037ba511a561436a8cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "380c1ab1ec9d6fde041fdfd78c3c98bb3f82337c840df2fce01c98832f7e10c3"
    sha256 cellar: :any,                 x86_64_linux:      "338221eb4053853a930a13d8b9491c8261e5fa49d17988ae38dc65fc8dea4652"
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
