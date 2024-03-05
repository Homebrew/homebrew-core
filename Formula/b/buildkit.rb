class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.13.0",
      revision: "2afc050d57d17983f3f662d5424c2725a35c60f4"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "871455c83bde35e603f18f3d51b66c383561f63a58927bdf22ed597170185e53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cae4f50c31410ab6bf8657e5d65ec23990248f13d37e33175e52a18ded31ad0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ac397fe7c6144a5ae4ecc20f6ce1f71cb36048e503f4e9ecd2c50583fb7afea"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f7dbbcd06d2cc31d5fcee50ae722adda4bbc59515c604364ee9dc9266fa5b3a"
    sha256 cellar: :any_skip_relocation, ventura:        "08a0fe0b87639e94e9d5d3abce592225a3ef9aa63472b08e181d0e00d9451f6a"
    sha256 cellar: :any_skip_relocation, monterey:       "2b57134c73c2fdbd1f1cb3d1461b3b391262fd6598769a2042b07b5bf1e1b9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d29ced5dfb6630cd95c6c8de4439d8c9132a5dec4a87dffe81e9c87e4f374a9"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
