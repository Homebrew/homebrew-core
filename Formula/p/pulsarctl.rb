class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.4.tar.gz"
  sha256 "7a41a8711b0e0e09903e8004a915cfd0b341f107a93a9ca5ddd43d6fa11c4fca"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cfaf891dfa3a16e1aa41c659bb8af6c94c4d199919822a59ae24f1fc1a0f752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cfaf891dfa3a16e1aa41c659bb8af6c94c4d199919822a59ae24f1fc1a0f752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cfaf891dfa3a16e1aa41c659bb8af6c94c4d199919822a59ae24f1fc1a0f752"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a6e58b508fcf6d18392def73b0d3854752136d52ebed07c7fdc8b28bf308e45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77dc9bc597ff816a9289ddc216d6a77d4f846a3e2b41654a95e471c93049ff53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d6a11ff427ab9c5a2cb2302012b09e457990a524b38b7b0208c5ccf0b05db9"
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
