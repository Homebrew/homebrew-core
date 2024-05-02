class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "096159986b73cc5f2550f61e94f6a7d7314718c0545642c2034836005648c258"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7430b1131e2639848a3d04b6fc9e40fe42f4da2169bbc05925d365a9fad03739"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dee5eaf50a7f4839dfe3fadfecccec903bccb0314c0e5998ba08b9d5a93468a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b723c1f53bb3c976c755ed0e8f06c97e2367d569332c569380fb6cdc43d0e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b95aa3d8f701772fa495c1d4df8bba1958cfced5be7f6cf798fcd9317d6beb52"
    sha256 cellar: :any_skip_relocation, ventura:        "bdb3ff2c78c6c26754f1b90ef3389adf7c5e208ca396525107f31ce876da78a9"
    sha256 cellar: :any_skip_relocation, monterey:       "1efb640eeb1fbba0d72c4960b05a6d33500577f5bb8906ddcc2149146d848755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb724af5e8882ad4ee6d07cadd94c638bc1055a542a5577ae3b97086afdf0f47"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  # Update pnpm and dependency lockfile
  # upstream PR patch, https://github.com/autobrr/autobrr/pull/1515
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9ac9588f76a579c2cceac9d7665031d0766268c6/autobrr/autobrr-1.41.0-pnpm.patch"
    sha256 "08d07758290377ad76f11bcff33a84c6e33d188554801039e647c142905802d3"
  end

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

    (testpath/"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec "#{bin}/autobrr", "--config", "#{testpath}/"
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
