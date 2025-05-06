class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "efecb61c01a9531154c2ce5ded664c869614f5c166692c469f64e845ccc1ffff"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac01e053dcc2b3e510940182d40cf63701549e594c40a5c7280531bf58521bd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb807765b922c2c342d75650a923751627fe0b4cc9faef23efb92cdeaffe45c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d12c71899afc1e6741938e29d98327d4138f5efb5f80ab805353a2a6aa93b22"
    sha256 cellar: :any_skip_relocation, sonoma:        "830cb20e08cf00eb7699c11548d707edd005e498c75b1354e81a9d15e6b95800"
    sha256 cellar: :any_skip_relocation, ventura:       "a1bd482f7859a4b0dec6f0ad880c2a591f564f19e3358de81b9d9043c4ab0ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09a0c1f580eceecf7bbc46ef173104e5a87cc2ca6a1e9550831853236ecd6068"
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
