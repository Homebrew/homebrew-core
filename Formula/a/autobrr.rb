class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.81.0.tar.gz"
  sha256 "c4eab2c95c2e78764c46cab7e05586db889376d141a92ecb25d0694764ca0aef"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a6e0465bc8c59a4714955f79392f73b7cb4e0f678edc85657e5db4f7d297922"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4c399318c940dbf004eb433e03bb48127c4811f44167fb19ec30033d10f7289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2bcf73a42f9740bbe5746468ebf25a6ab8035c0b37ae1c4c80ad97562a4af32"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b7b98dc45b18085fc392f9ceb0377076edca9f4b155bef56033b9779c2404fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e623873b8b35452e3283dd0d7cb3593ecba8b491a7ff49742a18e46ac7812495"
    sha256 cellar: :any,                 x86_64_linux:  "516d2e62fb11743ad2ad5d7ff7580479e01b54097ed915acfcd664f09394c454"
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
