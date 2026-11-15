class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "9b5ec00327d457f0acba20c301e94d2e1085448da60b500d58dd9a8d415a18c8"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e126a032e91519ed7c81799b3f2eac5ed9426dc562a8fde0b4e86be39954a781"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21fcd3bf5888bbccc10eb45c841c93df48126ca295929eb57310ea4fec28a5f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2190ba649f52bf3ef2478b21b5e2260e717ba504be8c74cf72095fd1024131f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b02e24ee6f3f95abc0db82af1395555a8f23db3d288e3338588c9e7b9ccad44"
    sha256 cellar: :any,                 x86_64_linux:      "17a6b64c61d4df3732837613da351ed0fb6bcbe4c2cc9f8b6be1dac1944b70e0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "stacks.test.grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end
