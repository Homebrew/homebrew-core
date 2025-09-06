class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "ca5a79ea8722e7ac66baf54ecc5b8ce94f90765e4afdda91ea82b65df3bf8073"
  license "GPL-2.0-or-later"
  head "https://github.com/autobrr/autobrr.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cebaf16d8a72ac08ab8a5c56b92851c536d5872067a14b6b6d5582ad4778ca91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0836fc15ec2ebc45d8879d458fe760838c48f4ad3848469b6aa4e72832212224"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5a9b3d2b853f9c4ee265839bccc58a475a38662ed65dae18c4320c99d07c20e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e6b0cf8cba2fc4fa03c4ad18a86107f82f66174db6601347bbf457b7709295e"
    sha256 cellar: :any_skip_relocation, ventura:       "d0528ce6bddfbf8d8bc4ad8d49e8a79523ee2e6e13eb64a05bb24bb20643fd59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e9de8afc1e4e49177809cc98bb053c4ef44270a27c0f07c193d2368a5753058"
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
