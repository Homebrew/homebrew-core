class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "86af259fc3f7886eca2d77129b3e9e285898d7fda1841fb4aad939193b9271ab"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f5b3e2af8d0cbb5a31b8dee1698d41219e0099b4309b8e2d14afde88a8cea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f5b3e2af8d0cbb5a31b8dee1698d41219e0099b4309b8e2d14afde88a8cea8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78f5b3e2af8d0cbb5a31b8dee1698d41219e0099b4309b8e2d14afde88a8cea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "423668f72a9724b8a9772ef94060556bbe3c26a28535ffe5e2391ce202151484"
    sha256 cellar: :any_skip_relocation, ventura:       "423668f72a9724b8a9772ef94060556bbe3c26a28535ffe5e2391ce202151484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a5448801517718aca79b82292d2cf8eef5ef38afeefe1dc0cd4935d336f493"
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
