class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.27.1",
      revision: "5fbebf9d177edcc7af06c36c78728fdd357bf964"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b871eaa7b12cb7567223cc16da4cc2919fcbc865a7e6afd80640b4cc8fb9f2e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b871eaa7b12cb7567223cc16da4cc2919fcbc865a7e6afd80640b4cc8fb9f2e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b871eaa7b12cb7567223cc16da4cc2919fcbc865a7e6afd80640b4cc8fb9f2e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c7a1195305ac0833f660da563d4482c36a2f7e0e08b4fb1ecae9e368fea61c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37070c5364aec2ca407e49e9098d29a671c650dd6e2daea11aab4619f84b68e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd9e4c766c82313476363e9514d467faa9557f3bac3a6d15fe3766be078b0086"
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
