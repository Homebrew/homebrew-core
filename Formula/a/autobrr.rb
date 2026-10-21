class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.88.0.tar.gz"
  sha256 "3ce8dc28511b87c05d051e81dd32fffb74e804b67b33d3a6d22e6a94217355f3"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d2b06212b89d7bbc6a63695d942bab6aeb5e324c9ed19ed28217a3b1a406b54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2e9e946530451beb1e369732e862bef615e57e09ea8c0ca28e036afb1468878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b95ae3a751135701dab70bd6ecae669f71c6f1965a18978179b45aa60c588f92"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d215e2b69a26d3d5e74c4b304486bcb3193440b61c9212bf7c73b91abd4ff8a"
    sha256 cellar: :any,                 x86_64_linux:      "4539c2351f23a5ba8c5fde12ffae0bdb98932477dd06d009ef8549d19f8246b9"
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
