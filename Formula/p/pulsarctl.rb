class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.11.tar.gz"
  sha256 "a1c52cf4e1cd995f0e9d72743b035acc1964d0d63cbd87af6d9eefbf38ea0db6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "338ac82b211d1123b1d2a9362b06dbd29902421626d42c75707d3cc2110b9183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "338ac82b211d1123b1d2a9362b06dbd29902421626d42c75707d3cc2110b9183"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338ac82b211d1123b1d2a9362b06dbd29902421626d42c75707d3cc2110b9183"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0702a83d1b1d9fe99edd8e817aafc55ad837e049e2a0c0ce102c8488f18247d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d4590767ea7de637533f713fbfd36c84b18077deac6936c20494ca09c805e8"
    sha256 cellar: :any,                 x86_64_linux:  "6d858ffe2f220c86a632f7bbabc046865f96d813f751a1529e87c7e26732e4f0"
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
