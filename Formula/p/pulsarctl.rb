class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v5.0.0.108.tar.gz"
  sha256 "24a6cefcabcef4632aec93de63e04878ee89aa3478f2b5ef30b37db81b5b78e2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33103d82c08d7b4c9d0d8324dd6b001e095991e2ff43c0c553b037c95d51f403"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33103d82c08d7b4c9d0d8324dd6b001e095991e2ff43c0c553b037c95d51f403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33103d82c08d7b4c9d0d8324dd6b001e095991e2ff43c0c553b037c95d51f403"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff5d3d8a5209d0fde6a2fbe20ecc1832736a691a0cceccadd76379ffd9fb752a"
    sha256 cellar: :any,                 x86_64_linux:      "00486089c8b45a8f6afc44d83a095fa79eebb2e2f18c20042f881ef22ba05738"
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
