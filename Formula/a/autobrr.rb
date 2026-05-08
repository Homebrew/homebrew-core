class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.77.1.tar.gz"
  sha256 "e5a86891b10bdb7498916723a1587dd97e8cbda6c302d16514a1d0b10e976dec"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9269b7c4d12ad98d8b65685ba2e6c5c7082e5a8ca61582aae64027af01f0ae2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8a1188c3baef41f1208c84e8ddc535b303f2aad2f433941342c3113a7870eea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84dba55f23d6df6b5ecbcd66de5e11559de7cd231ef7bb69ddc05044006227c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "32a1d55a30044a1a0fe68ddaf3b1fdc8b8d9db6bf9ecfea8f9a74a8f7762a284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24b48372fedfc96402a286573054117eabef00ffd889edf47adaf32b558333e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613bc9322644f9f6ca38caf14412d8815d0168fdeb226ecdb2ef5e30d7f2fe41"
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
