class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "fefa6c314d72f8baa17d1736a53840b39fddefe57c3a22ca6bf71a0d3d7091df"
  license "Apache-2.0"

  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "529892a79540c51506c30420a21091ca92b99a946006f2026d9d6e1289ce7be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "550431d06d6a83d411345244368f80d2e4fbcfa4805d85e8936cff6b47b47abf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbc9b655c97b7a32d2fa708c08ccbaa3b36c9d213cefaa2361984799b9719551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c0fd773d3a3b0c9bdb99fe05202287e74499f41716f9767af7b996dd0980916"
    sha256 cellar: :any,                 x86_64_linux:  "78f897db5b01b7713ff13d39ebdd6837a7bb77a4c2f1bcd689f355d5e575310f"
  end

  # TODO: unpin go@1.26 when pomerium supports go 1.27
  depends_on "go@1.26" => :build
  depends_on "node" => :build

  # Upstream dropped darwin x86_64 support in 0.33.0
  # https://github.com/pomerium/pomerium/pull/6141
  on_macos do
    depends_on arch: :arm64
  end

  def install
    system "make", "get-envoy"
    system "make", "build-ui"

    ldflags = %W[
      -X github.com/pomerium/pomerium/internal/version.Version=#{version}
      -X github.com/pomerium/pomerium/internal/version.GitCommit=v#{version}
      -X github.com/pomerium/pomerium/internal/version.ProjectName=pomerium
      -X github.com/pomerium/pomerium/internal/version.ProjectURL=github.com/pomerium/pomerium
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/pomerium"
  end

  service do
    run [opt_bin/"pomerium", "--config", etc/"pomerium.yaml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/pomerium.log"
    error_log_path var/"log/pomerium.log"
  end

  test do
    port = free_port

    (testpath/"config.yaml").write <<~YAML
      insecure_server: true
      address: "127.0.0.1:#{port}"
      routes:
        - from: http://127.0.0.1:#{port}
          allow_public_unauthenticated_access: true
          response:
            status: 200
            body: "plain text"
    YAML

    pid = spawn bin/"pomerium", "--config", testpath/"config.yaml"
    sleep 10
    assert_match "OK", shell_output("curl -s http://127.0.0.1:#{port}/healthz")
    assert_match "plain text", shell_output("curl -s http://127.0.0.1:#{port}")
    assert_match version.to_s, shell_output("#{bin}/pomerium --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
