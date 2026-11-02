class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v5.0.0.108.tar.gz"
  sha256 "24a6cefcabcef4632aec93de63e04878ee89aa3478f2b5ef30b37db81b5b78e2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "027d9487cd66234456f5bc0421538faef4df88d4d8718eec3aad3645948021a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "027d9487cd66234456f5bc0421538faef4df88d4d8718eec3aad3645948021a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "027d9487cd66234456f5bc0421538faef4df88d4d8718eec3aad3645948021a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1191861275e835f640362d4e401f493cde0731a4f6efd5764397da30d01bfb92"
    sha256 cellar: :any,                 x86_64_linux:      "76d457aa00b89b166bbb38cb1b96aff5d098e36a3b4c1e92473759fa879ef76f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
