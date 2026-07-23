class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.82.1.tar.gz"
  sha256 "5b92db1f06ec6fefebf96c9d54ecb5519dcefe9f73d9bd0892a0661256534f2c"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e89f58f045248a0e88e8b6986164cc60322183c5dca17d747066ad58a8cc09a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd32b3d53d05aa9dcc7d90000202c9264a420640e08c63fe9f883ff894450fe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63d741089e4d11bbb539400db82628ac06e0030537dcdc494531ef980ae829d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "db608567d544d4fd7b856a6dfa8dea2497c3c2168cf21bbfe897306e3268cbee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83dfa5edd962141e8f33a7f78bc91c0aad4fbce279742f79e76b2c97260fe027"
    sha256 cellar: :any,                 x86_64_linux:  "bfa4b6771d9dd293c5c84048d5cdc59cf23e78bf00289594ea3436a1be6ef84a"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "web", "install"
    system "pnpm", "with", "current", "--dir", "web", "run", "build"

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
