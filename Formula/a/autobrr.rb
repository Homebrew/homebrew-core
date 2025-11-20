class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.69.0.tar.gz"
  sha256 "3ff6814da9457355c63244fb72196934e2851a9c3df6f24081ca8a2b9bb93aa4"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4370a9125c5d5ae0c54f4aaee26e1923bee84b1af969e9c332d237e306289040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f73b7f33aedefd15756815aad1ee5b77e38ec835a89a208f580a90376ebc376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "933ef7216b4c387035681dfebb472f37c54a364a65823bcc0e33f508a569bcfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "513db99e23ed914b01f2b96f35bb7c5d011533266d5437e47962889560bfb9e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c92d72e29c96c17804f7c8bdb0297a3038ab1ddc3e419da8c7a093766f7c592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea8d8f39f07245228d6253a8f042a8f48779b99fcbce0487762412cd82f5fe5"
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

    pid = spawn bin/"autobrr", "--config", "#{testpath}/"
    begin
      sleep 4
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
