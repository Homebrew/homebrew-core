class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.1.1.tar.gz"
  sha256 "fad0a0dd1c014798aecc7ee40fa1080224e4399bc54e1ecb50efe88a0f7c6c52"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f223239b99f81b14bc42b66a6492c1779c1d57a534ead61e3564f3c9b9509fd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00e565ee60ccd0e14d2f9181169a2929ee615b06449c94581b6aeb1f10adc9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bcdb14a86677dc4213d81eccf3ade03762a7fc9062921f3f6b6068cd4c8f2c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0498f9c0497fa398089787763cb93fa84779be9744334a8e1e90158894302391"
    sha256 cellar: :any_skip_relocation, ventura:       "2afce73868bf0a435ca1fa3789105c8b0aa52ae080863fa3e9483db109b4966f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bf67fbd4f79d9b19519ad9a2681b94451f5af4f738291c3785810bf94afcdc7"
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
