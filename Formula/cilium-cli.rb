class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "cde0db85769feae595c5bd83467c85cc067923287adaf5782ec22cc9229464a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e21d0aca69d54099aba2f0679c85399ab42c3f2dae2ef96b0c956d9ce48cf8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6614ed0d059ed83da1f147d31243a599f81e13f36f52610d2f80135039b8c927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a52d888bdb8517aeb3c35139ee99efe9fd4361cf0b9f040e1f29abba04e66bd"
    sha256 cellar: :any_skip_relocation, ventura:        "7f36c7971d454bc46531faf55043d590ce7e2cdd4b1e5750cbf6c4b794801582"
    sha256 cellar: :any_skip_relocation, monterey:       "a343dd4fe8a487afa4c4f6e5014af21fcd814cabe699a1896924af1565e87fe7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c268120f25574cfcf7456a0e2cffe47c1a7d0e06b4566707f2633b822d85fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566c65ddd70121442861778f63f1baaa3f01b85dba7e9030216b8fcdb9f4074f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
