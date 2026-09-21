class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.16.tar.gz"
  sha256 "9b2fef566f4756190c816351205928ceeaa36d22cff05dd6659ac8c91950696a"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c700eeaa0afe5023284243e9574b3f62c0246045cbcfbce7d550cd2d8b518a39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c700eeaa0afe5023284243e9574b3f62c0246045cbcfbce7d550cd2d8b518a39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c700eeaa0afe5023284243e9574b3f62c0246045cbcfbce7d550cd2d8b518a39"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d13fdbbc6a8851ba21c59372e431e133f4577624e5b93ea80879bd609246a974"
    sha256 cellar: :any,                 x86_64_linux:      "a9ffccb4788c80f0307e26921a5617fd52722f38599f14d79f80684d1ad3dc5d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
