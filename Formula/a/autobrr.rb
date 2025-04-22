class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "8cfa26ac39d677b01cfd63f6379564e14e89607994fb36680803633532a8df26"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b7d022ff3c241759c0b286f083ca94f8451f6955d498dc4a9260a55018eb229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9e0f801eda76a97ca8637d3f3d337b00cc62580d0889737b3e0a1608e6ba47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c267bfd38964e0ae12e9ef8f77111f5d300254f9b05789d8fc32e1619086c50d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a61fb112bc03a4e543d1d5927f3b0c69bc9841aa944226757b14cde55d39671"
    sha256 cellar: :any_skip_relocation, ventura:       "93fee0e2b3d1b5aea0bba6a8ad051a823b5af13642245068bcee098abf727d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b8ca41691c5ef81a7314219f69d9632c789f0601f358f3da7c9363cf25c538"
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
