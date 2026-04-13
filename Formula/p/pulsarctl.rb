class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.1.tar.gz"
  sha256 "a531eee27121e14933bfd5b34717b8268e41b8acc58294391799fa28d9d690d6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87ea40306a6082b73f0cc0c2a92390590fe66141ce24194b44835bc96b2e63a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ea40306a6082b73f0cc0c2a92390590fe66141ce24194b44835bc96b2e63a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87ea40306a6082b73f0cc0c2a92390590fe66141ce24194b44835bc96b2e63a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "59526db4ba7a494b88edb24ef5e995d4ccc34043a7e49f303f2dd00afb3289b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a33a27ccf6633a03eea1ad35fb9a25ba9431873ce6ad8541c65f19fb5ded8a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "543c8572a9b5fa07e463c1e4a9387772504d9686452e656c573a954b9070574f"
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
