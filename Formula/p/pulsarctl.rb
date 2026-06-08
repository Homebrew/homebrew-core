class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.1.tar.gz"
  sha256 "53aec2a65e620ae3a5dab3ce4a7eb87463155bd436c59201d45970198ff1d8f2"
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
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0301a2157a89fce504e5589fcba14d17923836411a700b78166618a75be20568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0301a2157a89fce504e5589fcba14d17923836411a700b78166618a75be20568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0301a2157a89fce504e5589fcba14d17923836411a700b78166618a75be20568"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4e443b1d294537eae5e18b87dba125a55ae8e1006a02f55ae238a0702f882c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2190c1f92c73fdb4271526b8e53ba22788598a3dfd6c888016b22c3471047ce3"
    sha256 cellar: :any,                 x86_64_linux:  "607035380804cec3fd67055485a1cab56b69fd97b0f51b7fd8bdd2a947115c3d"
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

    generate_completions_from_executable(bin/"pulsarctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulsarctl --version")
    assert_match "connection refused", shell_output("#{bin}/pulsarctl clusters list 2>&1", 1)
  end
end
