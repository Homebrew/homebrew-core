class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v3.3.1.9.tar.gz"
  sha256 "63131a703b3d74251b84587f6d50f32511f668a6bcb83a1d09396fad774bc5c5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21686a2137d2b32d3b66ba793e2f39ac9c30f156227ac46a1b2a25cbbdcabf50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75d6849556bb0db347f48adfa6ea24d076c42784a1b64b02e495c237273e9dd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04f3048667bff15ea5db8a8495a737dfd7a0bb16559468b9659569af2e73b2ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "905e47107b802c2d4b7859cebae7b695a9c13f72b4f8589e42dfd7c9e34c1ddf"
    sha256 cellar: :any_skip_relocation, ventura:       "1c0bcbddeb411da378dffda38cf651fbe6bdbe7ed7510fb805635d82c1121ff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb62a81bd0e70ec2ae4dcc7de4ed46a5892fcddacea36e94b8237de331839b41"
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
