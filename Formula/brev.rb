class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.62.tar.gz"
  sha256 "d6d6fd49b9900122486efa432b56b839d7c21aa4cd2e73abc45037a428230b05"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7698f1096eb875bda2bb7f437252665dcec6956e44b837c1f51651948a17ced9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28fa26028b00ed17a7913d9d7e6cfafc717b133c768f49beffc35a9f2a832f3b"
    sha256 cellar: :any_skip_relocation, monterey:       "ee2d334aa6581a728217545e5767bebba499aeb39edc479fed2fcb9b1648775e"
    sha256 cellar: :any_skip_relocation, big_sur:        "28885f6e79dcf39b58174a317659e4754d9972a112d440bd768731ac12602ba8"
    sha256 cellar: :any_skip_relocation, catalina:       "e1e935d6e8c0bc775c9f318e0d4a8c6ece4fa3993a5386e24fcaa8f1e58608c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffb15dab0194af540644b705d4d79f90944772d35172bf4a391b5283f9110ec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
