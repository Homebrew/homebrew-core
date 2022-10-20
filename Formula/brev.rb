class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.124.tar.gz"
  sha256 "e53b70f313d9504414aeea0a41c80e7cdb29d61b681a2de9f63d683b37e7a823"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87222a67d7fb992164be13a9a4831fbdd328cbfe2bca9b1b9977c1882b3661d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f58137d032259ccdc61706ce645ed761eafb3f8b063150b110cac60b5df4ba5"
    sha256 cellar: :any_skip_relocation, monterey:       "64b8b4c239b9f4a1c8c89c64cd5de0aa6c455d4ec04c2e01fdc9ad22132bfa8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7354351c4d8fc70ac39236316efac8d61f73f815f886754ad32232799538a15d"
    sha256 cellar: :any_skip_relocation, catalina:       "9821f0808a3d3fe314f332532491f33a1116f6758ca08120df6c89d519131227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "711b5f237f2b96caf697e0c7c5c02863c2fd4053a64eefd3807df923ae078c92"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
