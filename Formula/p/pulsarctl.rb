class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.5.tar.gz"
  sha256 "3af015c37dfd8ddc93c8383aeb9c31ef63ad7aed66a22b4c9ef6c7f5348d93a7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccf113aab167626f0287aac63a45003a7b742825c6a6481cdadc9c6b0a825f0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccf113aab167626f0287aac63a45003a7b742825c6a6481cdadc9c6b0a825f0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccf113aab167626f0287aac63a45003a7b742825c6a6481cdadc9c6b0a825f0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec220b5e983048f889b5c2f1e63bfdff063e800ad3604a88e1f3d2cca298750e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c4236e63a60e940c3795aed70eae4dafa38054bdf8ca26673aa97972e99522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207662160eaf5ac14895882e271093408f51bd1f0785a6c8765c1336f49c84f0"
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
