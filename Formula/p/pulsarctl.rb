class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.0.3.tar.gz"
  sha256 "41b6661c43fe139a0183d25811dcd8e555294351062193b0cc24dadcd0e53a76"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05516b9bcee3128ec4e21885ec6dfe9b7d92ecaad1cc47293950b1840809f7aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29eab3b860abfe9735eb4b1681b17696f6f798ecc02d09a29d97d176f086f5ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edf912be883f6d875e5ddb28fd2f9ea3e48e701275396be66cb24f5ced21e46d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdad643982be0db4438808307100f3e4c0feff39f7a552c12cda93576766a601"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c8b1b6a694481a52ce5eca7493f9a8b2f7860f66de84f5c52a71060ea6b4e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f761ea58a1401a80ef187a76c22efe68ca680a1af4c4402fb763d8d3dc5c2c65"
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
