class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.20.1",
      revision: "de56a3c5056341667b5bad71f414ece70b50724f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b95d9385c2a97f48f9ca747b64c4d63628d3567ba39868720ba7474c0c83e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b95d9385c2a97f48f9ca747b64c4d63628d3567ba39868720ba7474c0c83e97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b95d9385c2a97f48f9ca747b64c4d63628d3567ba39868720ba7474c0c83e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "84de467c10f38df729f0ff6cf2514f6795e98271d0a16b24fe8d1ededfef56c0"
    sha256 cellar: :any_skip_relocation, ventura:       "84de467c10f38df729f0ff6cf2514f6795e98271d0a16b24fe8d1ededfef56c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ff4daa0ae88689a8be28a7b07cb982c3a849872d4383c846911774efb40f897"
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
