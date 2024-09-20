class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v3.3.1.6.tar.gz"
  sha256 "54bbd4491aa1a2f3c2aff596267404c372d74e5002c92d832b42fe51197ef81b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b57cbd9ad2d99b3d517a071e4729bb8adf2cd471f8bc8696614ccf46ac8638b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c93e8a24914cb1b822a2fa15aeff004c0ad54859aeae437731ed6178769717"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6e6f43b34c640954f43a142258c3602815918efb8049184f69f546548f652f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5dcdf83df0dbcb255ccad7e4a2ed1c36198c291988a23cb7831418da15694c4"
    sha256 cellar: :any_skip_relocation, ventura:       "64e9a5d232a9d7c40c47d320171da6ef039ebbd846602688268db36ae1dd8aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150da4cad99e528b7104e85ced82a71f1abf342c7c405e6dda5b94e72f544144"
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
