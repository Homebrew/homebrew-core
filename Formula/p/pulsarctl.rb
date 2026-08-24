class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.12.tar.gz"
  sha256 "f7889c92639982f64113f9c81c4f371880511f015c8de68d3f810fc3b8b5cfa4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e976a8b329a9bfe845ca26f1dedc0d7d48df2bc508b41de3929fe83783b147de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e976a8b329a9bfe845ca26f1dedc0d7d48df2bc508b41de3929fe83783b147de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e976a8b329a9bfe845ca26f1dedc0d7d48df2bc508b41de3929fe83783b147de"
    sha256 cellar: :any_skip_relocation, sonoma:        "61b7b2a7e8ea0082d21a6ed4e8464154c8f2648c50ffcf88d8e77ebf7b7f15f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2beb16d4ef715bc1acd286c4da215e7e7c43974fee84fee903fe398309639bbb"
    sha256 cellar: :any,                 x86_64_linux:  "cc4a9781c084e2f6630623a64e84817f5c2b1d40353f587fd115a7caea8e0a0d"
  end

  depends_on "go" => :build

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
