class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.90.0.tar.gz"
  sha256 "188462dcc05dd3781cd906f79708ffbbba5e058053cc24e27c0cec1059d23c02"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "04efc62259cf4f0e74356bee865822dd10bd9fee4ee8250df5b9502cab856fc3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5d39852e247000f8b9b6ec9b28fa749e954222e7fe72ad1d26656d9881b46e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ad5a0abcdba1caa9f2b8fd561289914d403eac2c2965607b1825b9e04a39ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3f2dc9890ff4696d65a43925f09df19701a42ae57305d8b0ae47efb0f7db4c6b"
    sha256 cellar: :any,                 x86_64_linux:      "5f817e8db33bc278d8539abf704dfc8ea9ab8ab30258bfff3c0858a2c885396f"
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
