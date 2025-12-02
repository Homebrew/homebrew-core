class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "3c55e9b95e875a51b18af16ee8f5a74230f94d9266cdba11ed1ee69fb4abe753"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "093e160bbfb5044619f12869850385a6d10fe581f9f1ee2cbef611d12505212d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d983491ec1d2809d31dce00ab51e1ab38b5333cf2ecea14e7770179102bdd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0b8480025383ab6606251f1db93dd0eb64baa7b3732cf95711ef78a18f3e9eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e370145a6cf130269f0b6aea8b0af703228767193285b53a6524ddbb3361a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2028ab857bdd85abbce75ad9775370553a13363ad131781d798cf44f5c31925c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a54184e46f76c7aa1e9340b8a161e1dca4310f9253dbbe2f47d6a1adb59e3b17"
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
