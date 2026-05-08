class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.2.0.6.tar.gz"
  sha256 "26e76144bd1203a6ef5dcbc35789b6182fd7ea701c804d7ad4a831959df2337d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b4b2a5279afb6cbaa1a99da8b3492fe4ef95b117fb623ce59301ee00d60697b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4b2a5279afb6cbaa1a99da8b3492fe4ef95b117fb623ce59301ee00d60697b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b4b2a5279afb6cbaa1a99da8b3492fe4ef95b117fb623ce59301ee00d60697b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd1c6a7bfd6ab65738387f2d39b9c9da6621e71890cdbc2b51428eec6baa0480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da95f67eb5db41586d734e3e3351e63c0874083a836caae7ae4463e463dafd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8de0dbe064033eca4479c822b7b558b1a249c784fd20fa452146f4c7b67587a"
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
