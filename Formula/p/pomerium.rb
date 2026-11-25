class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "2caaad01731db0cc2469306ced1467dd7fd5b75c7bac77cebc1623d4bf27c80b"
  license "Apache-2.0"
  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    manifest_sha256 "ccea19752655840ce4c1fdc23869828232e78aba7ed1ccda099235c6479e8433"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b32b32b626331f8edc1a3d9989dd0c8fa4b6466d087ec59082fe47a06b2b162c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1cae41a35eabf5b24f3137b33ea8930b2d07657632fdc185a7cf4ee3f92105fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b55e77a8a3590bebbcdecef4f51ebdf25564add3e7271493256488e765234d32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f487271c12b2029fe0d73218cbd91278cbd2528eea75c5729d3a8e156a56e6a"
    sha256 cellar: :any,                 x86_64_linux:      "38831ae1e23cac260c61ce780fc79a3d1aada0cf3a3747c895e6ed29952ea88c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  # Upstream dropped darwin x86_64 support in 0.33.0
  # https://github.com/pomerium/pomerium/pull/6141
  on_macos do
    depends_on arch: :arm64
  end

  # `test do` block runs a local HTTP server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
    system "make", "get-envoy"
    cd "ui" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
  end

  def install
    cd "ui" do
      system "npm", "--offline", "run", "build"
    end

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

    with_test_process(bin/"pomerium", "--config", testpath/"config.yaml", signal: "INT") do
      sleep 10
      assert_match "OK", shell_output("curl -s http://127.0.0.1:#{port}/healthz")
      assert_match "plain text", shell_output("curl -s http://127.0.0.1:#{port}")
      assert_match version.to_s, shell_output("#{bin}/pomerium --version")
    end
  end
end
