class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.5.tar.gz"
  sha256 "de4cd8075ce64a82850a51e1a243bff4686d9eabe1b7d129a5dac256e68c207b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "504bb88b49121ddcbddad55b08a0e0164d5efdae815e9b2dc4dfd84deaa3eb48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "504bb88b49121ddcbddad55b08a0e0164d5efdae815e9b2dc4dfd84deaa3eb48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "504bb88b49121ddcbddad55b08a0e0164d5efdae815e9b2dc4dfd84deaa3eb48"
    sha256 cellar: :any_skip_relocation, sonoma:        "05a7058ce08e658abb5975d44a16cdcd07724b8b46d93ee0a2b5107a00e8379c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c19e51b9a3c2dd5492c8395937cca1baf38bbe82c3ad463263c9762d1b6d38a"
    sha256 cellar: :any,                 x86_64_linux:  "252a771720e270a3ba9b677937a206f7c9d3c95c9f0689d210b48fcd822e16bd"
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
