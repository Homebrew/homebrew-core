class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "fe0f3dec41377c8edc1e6261117e1551201add3753f6d5b8c4d68a1dca006ec0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1b8a3bf08e4ad72923cf3a55a2b84c6df6544468ba3a0ed93b910ef07c0740a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5a42370a2daf0f2fffd36993dba948c422ecf3e98d026183b69a9d3ab2586da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a17dc06a1e519202acdce07a8962cb94441b6f8b149325c714ccabd2090aa810"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a1f3ee933a9863cccd42b8130411fb487d64506576ca988c95b7580d2c089bf"
    sha256 cellar: :any_skip_relocation, ventura:        "178c0abdcc00a3e294b2c341bf771a27e52a359bb1afd5c39710aea3687df47f"
    sha256 cellar: :any_skip_relocation, monterey:       "8dd762e9b54e17137a9d881b7fc4407c8397859557d290c6e9a3015469c13bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e99467f0c77aabbdc527217f908336d49adcc301b2d2d9c9b76a838489da46c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npx", "pnpm", "install", "--dir", "web"
    system "npx", "pnpm", "--dir", "web", "run", "build"

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
      exec "#{bin}/autobrr", "--config", "#{testpath}/"
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
