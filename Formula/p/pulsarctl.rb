class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.1.tar.gz"
  sha256 "cd3be20e60009278847280498c54478c2dc03df260279c37e442199a065196c7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83e1958c3566ef1876e91d8405cb268d1e1c65e0387d7761c4bb7dfe1152c4e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c05cc856dd8c563e18efb08e75656064c6297c9056f439659088c2cfa9d06a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6996eafd1c35e6620a4b2603414471383aa5779264568cfaa27725c77272b629"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac631d62517ac72556972c629793be40e0cff72b8dc11740cd107bba85e7b813"
    sha256 cellar: :any_skip_relocation, sonoma:        "3858b1055605ddf172d957a62fb28f8028373657f678b369d0b9979895b01163"
    sha256 cellar: :any_skip_relocation, ventura:       "1ec3253c1205a89212c127125f8dc9f4c5dea3daae1689b45c7e354a11a737a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee210804090cbc46904405e37cf2cf7f748b904a2d319a063924c19680b93783"
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
