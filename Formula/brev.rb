class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.152.tar.gz"
  sha256 "98eefdc326b9cf99049b3cad39ce8f677830260ebee2414aba462ee4e0286369"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb8a8149cd6def704efad282b3df7b3033b17151718ede110f5d4f62a595902"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "917b54038bca6d35010df555eb998f69ab2630ca09bc15c9d4358d269289610c"
    sha256 cellar: :any_skip_relocation, monterey:       "371beec24b71cd246fe274cd05202cb8c44cf1ec625af324ad2f180b70124a88"
    sha256 cellar: :any_skip_relocation, big_sur:        "df0b3a3089a39c9babd88505602ef29fffbbeb0dcd6177f758d100e02389fa30"
    sha256 cellar: :any_skip_relocation, catalina:       "5b6ca9ad84fac6fdbdf416c30091db4fc51bb52c305b704c994eb3e4046256d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b76050667afbb54b3b6bb0dc23061a39af3f75a0d50bfc1d656a7ac2388914ff"
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
