class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.66.1.tar.gz"
  sha256 "8fb0e85408a07d83099740a2e3bde3d6b8bca73a7d08f7e7c719f5c972e3e8f8"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20ad25543b88e4b3220a98487907c3890c465263cdb17532fdbf750d0dab34c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b19a423042bccd1019ec5a96b0217ca631d99817a8062f555ebe4f443951325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f7260ace13c3fcd2b62e7ffae9a9a8ec693341c4652f0da06d67868d27cafb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "362bf94fc40a7a38835102893c7ef64c7894d3b30a8a67f546a8b2e66729a7ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "874989382146ccbf54ec5536bcb3b2bccc9959110f655e407c94af6b6754ba5f"
    sha256 cellar: :any_skip_relocation, ventura:       "7547ba20eb1d49ac24f0d85c0ec9d227491a54247de33962a92c6b6efbd02691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492e4b3428ff8ff686baf0719e88fb9db392b5c07f5492e6fc169b0355a1c18f"
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
