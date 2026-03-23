class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.3.3.tar.gz"
  sha256 "66b650128ee41692370f493977a3c7900e5c8950f94c987dc21dbbdb734f7049"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c049049a68c1c3ae46f83f8a0cf0281aa9f65888b5ccb8a5b14d4f17c013439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c049049a68c1c3ae46f83f8a0cf0281aa9f65888b5ccb8a5b14d4f17c013439"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c049049a68c1c3ae46f83f8a0cf0281aa9f65888b5ccb8a5b14d4f17c013439"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f17a38e8eab49c1fa5806ee0507c7025c5f628672e256b51e3a239c60885e07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cff602f8eb6f0bd64baa02282074745b39d98e194a6ceda37a70ee239bcfc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ca21eff1c109ba969dcdf92eee52149e0e7506d4ddf601b4c3359dcee124f5"
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
