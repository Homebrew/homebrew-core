class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.23.2",
      revision: "40b2ede0ac0a37030f9959b4a28e9c6c8ea036e7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "569e7dcc76f39c5f3a368cbd9016e63461bb0d827d70fc601f6cf4cd1dd06144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "569e7dcc76f39c5f3a368cbd9016e63461bb0d827d70fc601f6cf4cd1dd06144"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "569e7dcc76f39c5f3a368cbd9016e63461bb0d827d70fc601f6cf4cd1dd06144"
    sha256 cellar: :any_skip_relocation, sonoma:        "23cefcefa7f55e74218ce3f31551d52b7ef639890d53cf65e525ee1be9c86539"
    sha256 cellar: :any_skip_relocation, ventura:       "23cefcefa7f55e74218ce3f31551d52b7ef639890d53cf65e525ee1be9c86539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53d7990aecb0d46d6dc06d71af4e01e2a6ebb492aaaf251c944e5879cddd646f"
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
