class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.7.tar.gz"
  sha256 "1b520dd1a0c60dd4149fff154e5b35afe83634a52fc645a69d5f87a030a3c193"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9004410f1ba74ae5f2b52931d8db77e119417c1b71e2f10f216a292fb4c9973d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc38c82e0f156f9d44b9405e2ab497a521b94ebce6f9cc17758b0795267aca62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a92ba5a184f8247a4689032390bf30ab1c4b268d8d177f1ae297da58c73e8150"
    sha256 cellar: :any_skip_relocation, sonoma:        "26c19e1c15d0714f042c7c6ecca83eaaa679793cf0aad2200821085483cff482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f86ca634cc73b67471a4284d54c621c2ac6541ea5da286c789e67656099280d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce4e6990840ceabfe3ca6a0142fa5b91ee3a89842fb1b57ecf9787e099ebf3a"
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
