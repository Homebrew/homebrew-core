class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.212.tar.gz"
  sha256 "a725fa91696482a48105bc547e0b0a8473cc4e7a6820213ed625b0d83b1a2235"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04f590e9823675e0ea06b8f22e2b8c59e600bd30fdd46b5c58ac7de418f8f4ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b5cb55f7c3f7e038abd9d9bcfd1a603a84ff3ce53dab5903f6eefc1aa7abbf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a889a47f4cadf6a706c806154378a8f4046907e461a85f04f954bce625fbe56"
    sha256 cellar: :any_skip_relocation, ventura:        "b42e76c3811ffcf371ddcabf77820ea02e8ef7c6a21ad87ce0c94b4a3ca6ebc9"
    sha256 cellar: :any_skip_relocation, monterey:       "b2577f7d3bc3729a3d0e1dbabef12af72257ba6eb9fbd573e1dbc5e94d1fbd9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1395ae1720b65b1b20dc3176b415e667b29becbca9c138d3b925fa900c2b311b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c748ff2ffd0451d02542be1a745726eb8aaaa5b0745111d21329418431f3539d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
