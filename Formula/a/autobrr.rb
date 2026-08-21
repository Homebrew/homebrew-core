class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "5e0a0fc5b88ad23cf094b6c5f1d41ef73cb319c921fbf3784953cb2ced30dc99"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05f51cd77574e2eb5cd46a3ae90249085974164f0d099c733e49edf862fc36d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61a8a3af1f4ebbcb58a34e029f3e85ce86ade96277fda312241acec24e1c8b27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a289c92b0e66d07f660f80bc5ba100b0c3f9851e6e656e047a860a93dc76673b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dde37384d95f05ff29ee0804bd0f7872a5b9c5c65a86e368de40f4e88d882a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea1e4393e8e7cecae8386f1df58c0af920bc41feb995009fabeb5990d6ff00c8"
    sha256 cellar: :any,                 x86_64_linux:  "cb37906f3fdc501b9fdf87f0c65f9166da5101b6dbc44de88d279ac4d57f4efe"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "with", "current", "--dir", "web", "install"
    system "pnpm", "with", "current", "--dir", "web", "run", "build"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags: :goreleaser), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags: :goreleaser), "./cmd/autobrrctl"

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
