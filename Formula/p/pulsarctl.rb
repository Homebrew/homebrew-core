class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.8.tar.gz"
  sha256 "d0399fe71f5d2ab35642f03bb7dca7d4fcf6111968a351f6d851f7f921886381"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f40a9195a52383afa94f9d9167f2fc956807e153fd9f893ec430beb7528701a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d294d15afa492956173429627d8b19ee92facd522f4091d2fdb58f0e7294ac97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb9567069323443343b33f028d71f257752b6e37953eeaa31e5b28a04596d81f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd53ec1683fb2ed7aeda4db15360d9948f859b797357d862ba5a7992c81dcbe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69a1b617c5b9ebc446f5f3224ad6a88da1cd37832ab2896c382f819fab85c3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4749725776f55a7d251e84e635c3776a5d09a0fa4045b7a4c06f44572525dd"
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
