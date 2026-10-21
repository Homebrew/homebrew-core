class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.5.1.tar.gz"
  sha256 "f8e94d8eeca21439b998849fddac476da82d4bd50b767230c2449cb55c428a65"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0d99fa8d217156b046df9447aca040417c27b0f9417264110ab1d5d5588fc79"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0d99fa8d217156b046df9447aca040417c27b0f9417264110ab1d5d5588fc79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0d99fa8d217156b046df9447aca040417c27b0f9417264110ab1d5d5588fc79"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f713e9a60de1af4fcb8d3375fd0fc87024fd8e08e4ec291255415514779d83f6"
    sha256 cellar: :any,                 x86_64_linux:      "111a1ae92d9a73078bd92a12d75b44ddb238fa0214acbf6da189d884bd9df011"
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
