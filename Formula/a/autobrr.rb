class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.63.1.tar.gz"
  sha256 "fda27153e95e43045bc562f8ab18a2348e42a8bdc874b05b3d5a13e8924b9e46"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54872d6519dc868f2aa9c71eb31c59377ddeb3743399d03fa032b1af06b5c683"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d16d04dc256b115af21da006a5c461bd1f3dcd84e86de34a2dc857b91e908f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77f48070623ec236dfdba4f37847f6bf85fbdb62fa13833837d6f5e9331ebc32"
    sha256 cellar: :any_skip_relocation, sonoma:        "11a838bbf16e1d0436e9e75dbaebc5e619b958fdf25e2aa4c9f88e8db7d6e421"
    sha256 cellar: :any_skip_relocation, ventura:       "efe94677260e038cd401f280ffe785124f7fc98ea367fc5a00aaef24dadcb7cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed87621012721cb861d947e9a6360e2c9bf08a3d28329cc0152d8d641a4ac1c5"
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
