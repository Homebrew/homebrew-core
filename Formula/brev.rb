class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.236.tar.gz"
  sha256 "68e1ba4821863336e270d1721a88cbc758d8cad7f758d4f49e5a0c27a4c7928d"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af42a78190580564d601a87a684764b93885ae5534b444052f543d5fb3684007"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4e414468d61f412141bc0e6050d483b1bdb9e83229e032412482fc79712ca5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89da545e04cd80b70295d160d2fc63763b18647b9247068e02d5c37f5be7d620"
    sha256 cellar: :any_skip_relocation, ventura:        "42e5e1868debdb10f3c72e9e42ee143e802085641476c5c4c70e6f3ed7050606"
    sha256 cellar: :any_skip_relocation, monterey:       "9c24d11789789b3d75ddb3e4fb481a559ec2d5da83d85af5d18f7eeee87958eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dc91519f3ff63d00c3dd1065c88567e1a7172be680b62f2194e19bef33d1f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53de9f1909d1c2f43065ce868f6eab71b5b5b258b880cc2897523b829bc8abec"
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
