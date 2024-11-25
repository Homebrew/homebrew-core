class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.51.1.tar.gz"
  sha256 "39ac905a800ec62105730a30b915e2ca9e4411cacd8bafb2f694db7cf19ab270"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5d587b60dfed23777867994cffcd18445c5635a317c720dfcf00bd5921a4f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5d587b60dfed23777867994cffcd18445c5635a317c720dfcf00bd5921a4f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b5d587b60dfed23777867994cffcd18445c5635a317c720dfcf00bd5921a4f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6e292cbe28bda7ec02a59d60f6d09c43f873a19d8c38a087697dcaf0c2e2791"
    sha256 cellar: :any_skip_relocation, ventura:       "c6e292cbe28bda7ec02a59d60f6d09c43f873a19d8c38a087697dcaf0c2e2791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d6011545222f590c669240603ba44c8f6325c1f7da8a0769cfb423f8dc9b25"
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
