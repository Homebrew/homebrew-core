class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in Go"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl/archive/refs/tags/v4.0.5.3.tar.gz"
  sha256 "6bc2312112a205e70c5a480b3fd502eea16b24c1ab7bfeaa74de9b8e6385320b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "877a5c897e254edfaba79e89654a20e0f15142107530b4dae059c4f746fec7c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cacc82fd55f01d7bf77814f34af0845fae188da06d896c60b17a8ecb31c6ee0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95cf3c8f159c6b0af86bbb3fcbe6a9b76a4004c2fad80eeb02b2af3fdaed313d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b175f02c7c184c06fbebc7525d16850569bed67d11df94202e216786d2f7bb63"
    sha256 cellar: :any_skip_relocation, ventura:       "4e9b03ca553698b319c7c1ee2ab7d3bf3aaec5ffdae0ad18cdca16e7967045a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3efd4f010b9c884fd232e03595cc755f4d12bfb40ac0be3cdd8abb118e3fae13"
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
