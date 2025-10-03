class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.67.0.tar.gz"
  sha256 "b38f8f2b416baf1c539fcecb282434d191fe250ccffae6b5e9cc14935a6a2185"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68f2e2478386d3552080e60bd32ed6002b461dafafce50d0547e9a9125f9ee8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9fce540b2380edef27225d9a3a8a7e1d4bd9abab7d8030f3e0c65c1a3da1afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f5183f5d2077a52baeab3766e08d9099d8de1fee6d1e60aa9823817a91d7fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "58a99a098ad97f508e80a2dee1432ae5850e9b6670c85b2beab8e3758d346971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d1f5db43edfbc2fb46ff734db76716802a94a2c90fc19e9c5a76906d72f8c20"
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

    (testpath/"config.toml").write <<~TOML
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    TOML

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
