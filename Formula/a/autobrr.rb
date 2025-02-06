class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "025d0b2e2820fdd5f952aa76d0a961c3b176af0644235c1787392d9c8b9a6729"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cda1ca1b20c9ffff943dc92ad01d440032d0f75ab43feb431eafb0a2592ce2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cda1ca1b20c9ffff943dc92ad01d440032d0f75ab43feb431eafb0a2592ce2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cda1ca1b20c9ffff943dc92ad01d440032d0f75ab43feb431eafb0a2592ce2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6ebbe5cb694985b7f584adbba9f9be30a73363b7132dc36e6169083723f0bc2"
    sha256 cellar: :any_skip_relocation, ventura:       "d6ebbe5cb694985b7f584adbba9f9be30a73363b7132dc36e6169083723f0bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9073f4527d31f592eb18fbb99d9910b3341b94a50d0243e841f5bac2aa3c75ce"
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
