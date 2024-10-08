class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.47.1.tar.gz"
  sha256 "caeb2dadd9b5c3b40122c54d51e0ae1903ef034e970f9164342df4d671dbb5de"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9c5d96c5b5fbafb03462c30c629e32fa623927c3beedf25079ef9df9afc178"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9c5d96c5b5fbafb03462c30c629e32fa623927c3beedf25079ef9df9afc178"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba9c5d96c5b5fbafb03462c30c629e32fa623927c3beedf25079ef9df9afc178"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff7111c32c16a6298e1f7e35bcc1540b25b8d9437f2fba2bb62b2f3cffefca01"
    sha256 cellar: :any_skip_relocation, ventura:       "ff7111c32c16a6298e1f7e35bcc1540b25b8d9437f2fba2bb62b2f3cffefca01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1bf62e3385917f1749d63cebbb43f62ee8143fb1b589707ddc781a70cad201e"
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

    (testpath/"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

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
