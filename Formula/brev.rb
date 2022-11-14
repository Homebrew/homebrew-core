class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.171.tar.gz"
  sha256 "e029699857da6b9df9dc36cc46cbf38495af1c13a0610d91f1e15a9723f5a41d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f82fe03618b025e1bd51d323f38ba00304c8d3a5787aa734eda29c51fe2c9d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "971dec394a5fa4d4f732a8ed42f6f75f232837a12384e5e98cb0036bb2425144"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a90dff9a558003cb2eafac67cf1e9ab8c4e36367becb1b47ad83b38c6a79898"
    sha256 cellar: :any_skip_relocation, monterey:       "642750ff299c1ec52c1650e75359dbd059e22a66c8b36d5e04109fd16b1330d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2494021c8b83ad29dbfa9c5ae046beeb614ec068e14bbafc888a48d9ea658a29"
    sha256 cellar: :any_skip_relocation, catalina:       "aa39cbf883fa992d47d08241bce7262bc789435fe3dd7adac3c55ee244cd09ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8be5409cabb02f04414b3b2e4409cb036f01ce032a81103b70f7ace7b51bae"
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
