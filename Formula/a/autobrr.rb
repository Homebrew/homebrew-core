class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "6e7b57cd426e530296b396639bbf141df0b041382aafda36e5bb34cd0e696756"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9067b34617ba19ece4d82b7d66cbbc073242ccc55ca744eed77bc2db6bbbc6d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5c24f057e57f88a7f1f6f738d838959e670e0bfb8baa98cab1bb92d1eb55dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad8b325c771dfde86d6d1e7721c3878f517ecb646b5e25017eca56d08910d23b"
    sha256 cellar: :any_skip_relocation, sonoma:        "91e171a66aa7f03fcdaac4b432c1d9b302fd0aba1c600f26e4589e16cfd3373e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41933edc1c94184c804b25c0381cfc2409eeea723f43a593bdf0abd85a3b320b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7f742308801c6cf1f91300fc44b53143afd12425b8ebe4c245f72d5db114e1"
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
