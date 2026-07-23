class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "71dedba9b1a06e55bab46cb0ab7ad6f81235a3ab6967f576e4429743ccf2e97a"
  license "Apache-2.0"

  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49af7d6b1c508aff852ac42fb6fa83a3336234fd94ab5f4768b84a943725a688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6434a4f6c5a5f3e23dc75d4d82f84f55b04a10072976a237dab0527fc79114f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d0f7be64b8f2a33ebba7338dfe92140f0d2b3c5152d29ebe65de8d497044e76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "574e0a131aa10790f88e5b1aa0a62aff817ff41a4d0591daf3b338e73f92c581"
    sha256 cellar: :any,                 x86_64_linux:  "7fc7d6bafb46a66a81bb3f6017fe252e0df892bf9b5d2611ec12e9a357bfe6ef"
  end

  depends_on "go" => :build
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
      -s -w
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
