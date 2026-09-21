class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.33.3.tar.gz"
  sha256 "4ff8ca584b0350ba6cac14cec692515fac76510d758419c51c5d7f4bd88381bd"
  license "Apache-2.0"

  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17c6496a4b69440f3e9066464c4a581ee38386b0f32f25abe5cfae81d5e92686"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "402c7a7c05d67148f6e9967919a7c931ce4bdc4264732ee1c75b8b338cde3f26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "276027b55014dfb7305ab533456bcdefc147b0154fe02cf48cfa4be9e4067544"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1fd361b8e527b036baa61dceecb696e3a8eabb34222ce3bfce2f8c38d9913019"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e25db5dd613d85a9ef2e486b80b6af54052d8f4801101c2687755df7ea2119d2"
    sha256 cellar: :any,                 x86_64_linux:      "91ed1c1ce3c268b6fb705d4f08a2a0d557f04afacb949831be26233005e0065a"
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
