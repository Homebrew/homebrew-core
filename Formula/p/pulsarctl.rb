class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.4.3.tar.gz"
  sha256 "52786aef717bedc50611838b229285354e61b0f6f377e029e1e1d00780510a06"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16114435ed35d092aa1215cfea1ca6c2dff90ef3d41d44e333366d040a7c63f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52c604de1788bd352ab7dde49959341688363098aed227755092c159b918a0af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cac58b9f3690ec507d5678c7acaf3edba2c9735319af1eb4a1710443a846aa99"
    sha256 cellar: :any_skip_relocation, sonoma:        "f05d27c25eb1fed4598301c2e8b53adf71204cf5a52c285e812496a7b237f54f"
    sha256 cellar: :any_skip_relocation, ventura:       "2f566672ad41a3839d13a447a5d26925ca4ea42810677de1e8e57fcb251225d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc7ab4d377962bf746c83ca23c3f57a6f79c6e7489ee7f311f19db40412bb3b"
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
