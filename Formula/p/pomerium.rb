class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "75ef0eaa60d7e7bdc8a0b9173953a1b8fd2ec233fc7238813cd745dd4fbc47ec"
  license "Apache-2.0"
  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5838b147b04f1ef826ed1483de4d8b454b873e69886e41f7088b613ca319042b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6104560863460a8a3ad04e01ba19c4f638c83992853c956b0e5a262ea3a8d564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08d19ebc885ba92334b0bf3b8f74eb1ab030903a24b835c16ad5afc0222af1d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2aa1b910bf6ca6ad3494429ab5033805bdbbd6ad5db3821832e13be1b96769ea"
    sha256 cellar: :any,                 x86_64_linux:      "b840f226a7248670d826e9c163208357090fe6ac83982b4661e4553ca695f9bd"
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
