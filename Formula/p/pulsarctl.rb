class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.3.tar.gz"
  sha256 "7a300770c67468762aafab5bfb6f35c1cb899508c896d6fcf4d9c5d242ce01b9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88e828dfe2b831a2dfe16bc05102a048c505d09d29e9ab66ad5feeb21de764e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb9ba741345682c01fb0d5bdf014d191d3637b869dc2b16f513039ab659b21bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b8d5007fe034e63f6b50f3985b7e0fd5a25567dd368ec5833c091a19faeea7"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4da8ad110f4211470baddba87d6d70c8aaeb59565fbef0f7a0fd15e69256ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "042d015c286e8714363e86ee8d6720ec28ef2229945fac8439ca974c54606274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5622cb66d59481ace301d70906ae46029b1339c7032f45963b181d9eb269b95"
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
