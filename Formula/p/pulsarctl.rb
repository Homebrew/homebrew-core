class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v3.3.1.2.tar.gz"
  sha256 "d290124c764e1be20a34a35d381cc19c76dc6d1019f72374c9da6ff93895ff37"
  license "Apache-2.0"
  head "https://github.com/streamnative/pulsarctl.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3aaa4a8c26a6e535860f5178579c454d2df40c30b6f86752a04c22939e88e0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c924d269f7c6571882efea5adcefc5ebc65c35747068c93a9210a78e87317fed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5cfb84619c7b2fd511701ffa9d83f14636287e9cd223e06a6bafc5ee7567b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc7075ba9cbfa07d00b0a6a7f06616c0fb945e244103c7c7dd66c832fcfb0c31"
    sha256 cellar: :any_skip_relocation, ventura:        "92357ec2bcfc1cf516a4075f035640ba1247129a17d7b42b9bc1b0106786ff99"
    sha256 cellar: :any_skip_relocation, monterey:       "87b60ce96fed7b5099ce52aa0c1995c5c110878c8502d661a459980ffc39002f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46d35f2dbd973922edbe41e979b9150deff5afe35c48d0d20f744a04ce8119a1"
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
