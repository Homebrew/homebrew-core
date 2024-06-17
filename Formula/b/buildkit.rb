class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.14.0",
      revision: "4d9a4e5df9e11596a3261c1952cde3c6346be762"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0790cb312c8a7c17f43804192f2f5067e6f039b1266726fe03105b7ffc66fd54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "165293a3ad9a4fd1b5490188eda1c9564ccc0bd49a0eddf6a52b944536cde659"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13df76b111b387f70d2e63c68a35a3b5c08f813c40a75a886775d3827c3f3530"
    sha256 cellar: :any_skip_relocation, sonoma:         "7766175e49d88c80a011f202b29376fc0e216deeeb3a657d0268324f78bff8bd"
    sha256 cellar: :any_skip_relocation, ventura:        "613e074ce6871b9541c77a33aea0a26d6f478a8bbfe308a1a085ecf7afa49d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "b119d96035a52c090c3d49cfb103157cc9a445bdee01426189b0fe70eb056ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f2aad15309377bd82f836aa39914624b202bc5d68c395cf031f4c2c0f00650"
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
