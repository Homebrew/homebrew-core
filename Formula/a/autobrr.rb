class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "3ddb6f8899fc88f1166e698a1bad1a91bacd7b6757023f54b6dcf6201ff52d97"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "826116e8d968c435a881dbaad33e50e93459f38fa9d8e730a259340d7f942003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96832397bb69f8a4d9f1eb91b836101c526f1b6287a32f4624e198133075efe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd8fa2d934f195b3e242149ebf182153eaea9e92d7b69af8bbe45bf6f2cf31f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6811e365db7f0fd9c6194860a29cb84201e292af0494bb4fb84f06fc4bd04630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fffb4efd249307329077b328867b6e74237481abc4d3c8edb4826395859ab15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5f65c163ce46ec6e65bca73d2ba913961f6bb4fd0140fd026d269ec43e8a21"
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
