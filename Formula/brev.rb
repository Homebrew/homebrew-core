class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.225.tar.gz"
  sha256 "e6d0e96367e14ea1a61639ced618bce0945788b8fd1fd57b2105b6c0edc6a885"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1b0864a063cc6b44db17de579ee5a87d31e8e3eb34be97cd102eb1128e8a0ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "374d9e8c2f7d2eea3d4e699155298d441e41ae21706cd39acb796c44e20927a9"
    sha256 cellar: :any_skip_relocation, ventura:        "ef8325b1c45f10e3ef544dea3664e2e20263f053df8729a366128c54d76f1320"
    sha256 cellar: :any_skip_relocation, monterey:       "51d30d63be39625ffee97760e98244e73093d68a39abddc4a6e16d4ec47961ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "81b10903fc5f35f566fec85b962575797f21e2224f45aa8b7b0f70b516c24db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32501bd10d876ecd09259a5a23f3837bd2524fa01d2a73bfa861d0b0d580a709"
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
