class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.192.tar.gz"
  sha256 "9a2ed03e1a037ad66fcd284b7d82bec91bf6c143c753ace49b9967d0c3e1e415"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f62149c1331411a3a8f61e93a7549ae3e2d503bb7ff0e35cb0621b5ff8f5f594"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d03e4e5b0fb21e09a9cc4d3bd7e63187c685edfa00b390d3cfe3a8a55ce06022"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44b351b8804ddfed8fa06e42faa2b96d1c0c690f5b9546fb4a0836c782232f91"
    sha256 cellar: :any_skip_relocation, ventura:        "2cf1201e1bd308f5f735447e47471f0525a712570108b71bb71699a9807dcf59"
    sha256 cellar: :any_skip_relocation, monterey:       "1ace1a90a4393bcae943c22994f5cf12278ebb802b4b073f294bd108ec00dbac"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5643a030bc290eaf25558b823efc526bd3915525cb757db940f61396c07efc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cf5ea75186eb749440c1b065ca85ec825a5f307aa2495f57585a579c239b22a"
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
