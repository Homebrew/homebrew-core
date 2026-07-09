class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.1.6.tar.gz"
  sha256 "adfab8f33fde1dc6b2972973d467a7f233d8b3963df5526bca747ff68850ce56"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "753317e305f0cd4cb82b9842f5b28462b0ac4098d779ec980449237359115d38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e4dacbb1f189aa151998488852e9a3b0c10d9773ce698da67662eb75c2f1941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "849b00545274dbc9ccb0ad9463eb8a3cc0e83847f2c657c2bf70c56ac528e70f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab26cc329b1229f269506aa15ba8bd6dae247d5fe6731bf5f168c351772fce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34d90a5ffa9a05136aefdd7b2c4eccfe79fdcc7fce963b113015db2b2e96e1a1"
    sha256 cellar: :any,                 x86_64_linux:  "b353418f1430b05671a78bae556618b9e4ea6ab633cc268d0f2e36f2b514d9bc"
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
