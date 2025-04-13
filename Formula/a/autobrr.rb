class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "7915aa4d7fd9b4fe596cb7d284c3b13d9b8a068c7f87caa53ff2c8b47f2f7c59"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3134312adcd96d3c1fda60d0bec563d9192ea89f865c9bd4db5c88b03a50684b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66458de2ee7009c95baa7ca6a8d66bd8c843ffed408f966053985df6da53c1aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17f5a0c3ac0316e6c3a9374ed46c18f3ef316da0081d6e91473cd63ae2959282"
    sha256 cellar: :any_skip_relocation, sonoma:        "e65be082acf935df8dc5ba90a79b9f6fdfd26f210ea1c83b4a9238439e12a561"
    sha256 cellar: :any_skip_relocation, ventura:       "d502e810e2fe9e61c0fe971b95cf6aa1ca233e9baf9168bc4b48fbcf4b2386b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2b875ab073fb5bff36235a59ad64824188877de77bcf6c1ab7dfd43fc735a5"
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
