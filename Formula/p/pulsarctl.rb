class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.1.0.14.tar.gz"
  sha256 "0bdf751544ac9335a78e844af4ca8375babc36e11fe7cd633371cf0591dd6504"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbc3b37246811af1d24470f230c15e29ff1846c4352a11650d5c4920c0deb7c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc3b37246811af1d24470f230c15e29ff1846c4352a11650d5c4920c0deb7c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbc3b37246811af1d24470f230c15e29ff1846c4352a11650d5c4920c0deb7c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9533620665f6ca823d8b58cc46d91439d8b7b5fbe4bb7ff907b931d02d16a0c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "923acd87401977b380c0420d6355873064e686cf8c2507975a4899a487f58ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6763c46f0b647be531f7d04abbb530eace55b6d670a891ca7d0caab821ebf15c"
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
