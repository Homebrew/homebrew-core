class Pomerium < Formula
  desc "Identity and context-aware access proxy"
  homepage "https://www.pomerium.com"
  url "https://github.com/pomerium/pomerium/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "edcde54671715fce9428c94bce98c55f204ed83e5206a002793501034e1d3938"
  license "Apache-2.0"
  head "https://github.com/pomerium/pomerium.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12b85a0d1f23c90a7cea389a0b0473fffbaac8eb3e4712bdfbf7e17cf948f10b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56e2dd0c9e3b32e9ceefab87b910dbabf242a3a672b958e278c4ebac4872f3d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1dd049c7d5eb0972e9f167611b35dcb3e3e459137d061fdc583e17f27ed8b2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dcd665cc03aecffceec64b594bb559f3f77f12def24bb28c4c20b7b5da214296"
    sha256 cellar: :any,                 x86_64_linux:      "762bb1aec90bcd38170040abaf1923e2e8f4635b53552bbd5b465bb55fad3fa3"
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
