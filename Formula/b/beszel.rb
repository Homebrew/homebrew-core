class Beszel < Formula
  desc "Lightweight server monitoring with historical data, Docker stats, and alerts"
  homepage "https://beszel.dev"
  url "https://github.com/henrygd/beszel/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "92dac1dd5faed2fe47fe6cdec831ccf5b04032c33438e88fc354666f563090ff"
  license "MIT"
  head "https://github.com/henrygd/beszel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64c234488976fa10ba49215fbb967e763446ba83b603b8c460df07a3788d152c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "64c234488976fa10ba49215fbb967e763446ba83b603b8c460df07a3788d152c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64c234488976fa10ba49215fbb967e763446ba83b603b8c460df07a3788d152c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "306555ef268d9090431d43f1a17d78ce5fe5cd5b8192d242b471de76f3953c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5bb8fcaf6656abff89ed73f848ea46705ccb2ea9dc7b71df84b2af13e329175c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    cd "internal/site" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
  end

  def install
    # Homebrew manages upgrades, so replace self-update with a notice
    inreplace "internal/cmd/hub/hub.go", "Run:   hub.Update,",
              'Run: func(cmd *cobra.Command, _ []string) { cmd.Println("Run `brew upgrade beszel` to update.") },'

    cd "internal/site" do
      system "npm", "--offline", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args, "./internal/cmd/hub"

    (var/"lib/beszel").mkpath
  end

  service do
    run [opt_bin/"beszel", "serve", "--http=127.0.0.1:8090", "--dir=#{var}/lib/beszel"]
    keep_alive true
    log_path var/"log/beszel.log"
    error_log_path var/"log/beszel.log"
  end

  test do
    assert_match "brew upgrade beszel", shell_output("#{bin}/beszel update 2>&1")

    port = free_port
    url = "http://127.0.0.1:#{port}"
    log = testpath/"beszel.log"
    pid = spawn(bin/"beszel", "serve", "--http", "127.0.0.1:#{port}",
                "--dir", (testpath/"beszel_data").to_s, out: log.to_s, err: log.to_s)

    30.times do
      break if log.read.include?("Server started at")

      sleep 1
    end
    assert_match "Server started at", log.read
    system bin/"beszel", "health", "--url", url
    assert_match "<title>Beszel</title>", shell_output("curl -fsS #{url}")
    assert_path_exists testpath/"beszel_data/data.db"
  ensure
    Process.kill "TERM", pid if pid
    Process.wait pid if pid
  end
end
