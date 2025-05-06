class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.4.2.tar.gz"
  sha256 "b12d6bed9555a8d3b1a932961797f29a191bcc7c2b32e6ae608471166f6ed02c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd68350615e2fccc1d4409e61b298f5bf4fe8b7e27dbd19423998ea568851b18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9674dc9e1cfddd7a2f164bf8722c0e4130bbc3371dbaead2554b65e8c8b0af0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae56d869ba811772b8c20e1b9e83c1b4887ee0959756a789389a8c778208ccfe"
    sha256 cellar: :any_skip_relocation, sonoma:        "346b8d8f469c31474e73c67207a579228d05eeb5fefaca0a723e30696a7ab573"
    sha256 cellar: :any_skip_relocation, ventura:       "cb0073e48889b6ca86209e3e05494c5ae972ec991e9fb3479e49575505ef7883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87cf022299e9e4abc286c92bf05859ebfec37fac0564200eb3cee00515b16a45"
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
