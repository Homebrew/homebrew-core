class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.13.1",
      revision: "2ae42e0c0c793d7d66b7a23424af6fd6c2f9c8f3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4026c55b5de1d8bfeb1ce5d32902ef865432a04bde76879a07764930df36f6cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd046889c5439174c3ab2e250c983eff71419e711b66967b5fa8717df85aa77c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14dc8ef4376909c41a408811276b7edb4fed8898df7ee45a1caeb10b6d9eb4f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfa9a076bfa0556bc158aad23287d3e1150306a4f9316a7560c65d2c3676b19b"
    sha256 cellar: :any_skip_relocation, ventura:        "a382eaa6c00f8adcc477f5e6d859369217603ea7e06c2b788a9dddf941382144"
    sha256 cellar: :any_skip_relocation, monterey:       "2286ef39a08f994d9d99084b299a560200278284afe51fc56c9a9194f72b3d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "486433ba9099bf4a9c630e75017dd03c8ea651ff2dd93b49241b522b7aacdde9"
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
