class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.181.tar.gz"
  sha256 "0a33c41b0927a83a1e466b1b297c519ccf638e97fb74cc545a80821625428a50"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37b056468fb5d2bc8a9e59f5d123f5d185d3944fea51f8a89cc02fbcf450fc02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12aa9fb8647e4473b563f78387c8791bb9e1d10e0a7dcb2d3fdbdd5137b3b11a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c70563d00ebba3b1d7f5d2b3ad36f180beba353d8bf357f9ee4ec94c5e90cd3"
    sha256 cellar: :any_skip_relocation, monterey:       "8d10b74b382b43f6051af1852afa03288635ac54d845f89e54bc5b7ca0dea4e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a492361e3328959c1b625654e72fb36f9d6bbe7fbc6b1e59e886528fb6fcc6a"
    sha256 cellar: :any_skip_relocation, catalina:       "7f484de20e02d5277ae1515b6e0e470df20aa1eaf2715f540db84f7e8ac4d544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "812c56678f1e2e7c60cc43433f10bfbe6058bd7763555aa4991387311e123f6e"
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
