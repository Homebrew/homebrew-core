class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.16.tar.gz"
  sha256 "cd347da974697e758b3b4f63fbb3d77591657ad0d5e7df3615d201f18e3522e3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eec39e6502224dbf17d1135d60a9be506923eae010632819de8980955fe46cd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec39e6502224dbf17d1135d60a9be506923eae010632819de8980955fe46cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec39e6502224dbf17d1135d60a9be506923eae010632819de8980955fe46cd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf07e4a00a543a956634fc1269a781e3816b7fcef289ba21113cb426a250c1e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a47027b12749e338eda8dd1fe67745b3a9d701a9657838c3533b7a2cad516be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90744fa3b884fb36cc482294cc24fd6f756b4c3ba6e50670cb2631d0f8be664b"
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
