class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.1.3.tar.gz"
  sha256 "406e51bee4288d978b48ac1f4cfb7ac21547660d0f284e934b36d019ad21e0c4"
  license "Apache-2.0"
  head "https://github.com/streamnative/pulsarctl.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to check releases instead of Git tags. Upstream also publishes
  # releases for multiple major/minor versions and the "latest" release
  # may not be the highest stable version, so we have to use the
  # `GithubReleases` strategy while this is the case.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da89466d58784a3a7dfa66545ee156c5ed28d6af345bd05ad94056cd4abe2a1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445ef1245772751d6de4d27c92688bf81ece7cbd0a7fc81db7ea4fc313238f97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c776fe4e8c9e861124688ac5dcc8641f6da82091c7844fb1876f18cbe19d51"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfd4f1b4a70ec9fb87ca4efa341de2c13c0f696cd78f5e317be37b621625ba49"
    sha256 cellar: :any_skip_relocation, ventura:       "ccbdf17ebf8e1a7412e05daea7135134c6aa8524b03ce746d015d00f93859b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7ebc77e3ec39d6195081f2dedf93f616611f495476c2d6d18fe42449eabc22"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.ReleaseVersion=v#{version}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.BuildTS=#{time.iso8601}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GitHash=#{tap.user}
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GitBranch=master
      -X github.com/streamnative/pulsarctl/pkg/cmdutils.GoVersion=go#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"pulsarctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulsarctl --version")
    assert_match "connection refused", shell_output("#{bin}/pulsarctl clusters list 2>&1", 1)
  end
end
