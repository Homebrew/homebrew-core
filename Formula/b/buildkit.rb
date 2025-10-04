class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.25.0",
      revision: "14d1ccb56dbc5e1748c73cda77af2a61a5c3603a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c7efd0c7fa793e0aaa73f15be13720d619794b848b1ba087abda0c635b824a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c7efd0c7fa793e0aaa73f15be13720d619794b848b1ba087abda0c635b824a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7efd0c7fa793e0aaa73f15be13720d619794b848b1ba087abda0c635b824a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "44801ba46ccce5215671f0861a1f218fa6524d9c6f56a800afcd08a0cc455a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18256c2e4665b140eb3ab2dd24eae76165adbb7a98e913c8f6c5312f36e1d7a0"
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

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
