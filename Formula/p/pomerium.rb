class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "75ef0eaa60d7e7bdc8a0b9173953a1b8fd2ec233fc7238813cd745dd4fbc47ec"
  license "Apache-2.0"
  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b2cabfafad372a54467f4e66ae9bc59fa2aea5731f7f802668c05cfebb10493"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f298e910886f6f228d480fb42f2da9e5dcb0ecdb171331d1596c7aa9356bec6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43cd4dec34276d221f04e8ac1d9321c78029384a3062481ef34075d697e83421"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c464bc6a6ecb8a5c43bf7329e8f931b9b9f14d04e07a9a6d12bf2f07d265580"
    sha256 cellar: :any,                 x86_64_linux:      "ae812b6863dd5ee225f9767c66667f5351782773aa27118cb4e0d74b86d47c94"
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
