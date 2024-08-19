class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "c41d78dc3ed13ef52ecbac9afaf46fbe05fbf2e23a71ea35f35bafd718da2939"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea47b41bcadf0bb70a0ab05128acecb5a3c30f81ab7587b6883e531ae18b9895"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c320c471c61cfde1a15fbecf2b6cfe0a2d3888ec3c9e32b19235945eea9aff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e13119d42b79dd13f9431a66be1e6360917abcced708c43f6935581d6292fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "942a1d6feca746a762cd4a1c42979b5d340c3daba2baf4f6ccbf1de5d30ae433"
    sha256 cellar: :any_skip_relocation, ventura:        "910ce6a71b66293a7dba0b5aab42998cf114ff2577cf13ac2f8e5cca35423d2d"
    sha256 cellar: :any_skip_relocation, monterey:       "8cabc205e6d9769fa6dd30b8a8873518a1a783bd2f80eeaeaf26239b37758657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f735f57da6ee15849c8becce2aeb8a7ca53819b93b3eddc30259da6bcf7c286"
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
