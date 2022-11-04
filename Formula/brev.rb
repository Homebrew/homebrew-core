class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.154.tar.gz"
  sha256 "7f91e08d4d58fa3ab96a8494734501b94988849057d6b489ac621ddf64cdf602"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1101a977f9996c2d30826686207109fbbc6fe330f8f8cd4bbe998220d79e90c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44087d0f0ae30139381f149491de3a175eee0d3d4f071a4fd67833e1ade304ae"
    sha256 cellar: :any_skip_relocation, monterey:       "74228272a4fd8540cf9070cc8ffdcfa7b7c6d4533f241847d989d1349ba92929"
    sha256 cellar: :any_skip_relocation, big_sur:        "61de91d7fac54c5fb274ac6728e670e2836ae5e8798e306a7fe98d22f911878b"
    sha256 cellar: :any_skip_relocation, catalina:       "2041d4f0614dcdac128703f1128a6a078827b0366bf68d2769d412b1b2705258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec1b96e9558da37a0437c9c7fed70db0de922d4581fe94988bfc253be63c52c"
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
