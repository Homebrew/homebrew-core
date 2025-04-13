class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.3.2.tar.gz"
  sha256 "13dd3a4c676290dd182df13446ae150b626d5f73ced07e2ed3d1120e9400965e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c12ad274036b2ee31017e7a6182a25e311a79816cfd5d3663d8ffb68df294bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aedf9707df3efc135d31a0c7bbc7fd73c34e9f3cc4120ebf53167bf218506ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a506414e9cce19ac6517bd144536215546f57456a1c14f186e7457968b98f56c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eb3e6c4c45d7a6b627cd39d98660058c6a130ebf039647fba07c394ed2ff2d5"
    sha256 cellar: :any_skip_relocation, ventura:       "84553d831d26750ac52ce55d2dc09593ad3117739b910d2e802e7974f92c134f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62074fd4ca56522b8efe98aafa1b4180ed2323aa79c759f6cfd6d0a5ae21d16e"
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
