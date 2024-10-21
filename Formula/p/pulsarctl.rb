class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.0.0.tar.gz"
  sha256 "17edf5d0218c5a6707e059e5da6a8e6e72f83b05eee3cdedaa929f474a207d00"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a39139fcf281d1fac0b987f75ded8c774228a9664d6e845cfa695d3ab1d94f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094a640f7325a2d322d0ab33272c21a8f5c775be1ef4faa18b4fadd0a692e375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a395adc24ebad0246cf9453bbf35d98da933cb7985a9b4cb1d5de11817feb94"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6bbfb867b02305e27a5cb8c2145333eea613a8af1b2d7c6ee924a850be3a78b"
    sha256 cellar: :any_skip_relocation, ventura:       "0f5c3b44cd47c5b42de3d322a754edcfbec60bde7697168dc40c2b1b3cac1171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe1ec09b3e08d2459522f881e4d66c7af54b547cb596d5bc263ca440c71d18c9"
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
