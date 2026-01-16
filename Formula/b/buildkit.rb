class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.26.3",
      revision: "c70e8e666f8f6ee3c0d83b20c338be5aedeaa97a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7900dc7049d58dddc1b7f078849a5d346c9a9c8297a516c27e0718f6e80cc9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7900dc7049d58dddc1b7f078849a5d346c9a9c8297a516c27e0718f6e80cc9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7900dc7049d58dddc1b7f078849a5d346c9a9c8297a516c27e0718f6e80cc9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4e4179c69d6887b41498713909662dad8601d73d01c4a3003b04bcff13d1719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c7907fbcae91384d8856475da0ab7fb2e28fc56ebc6bc04bd247b0bbbaf3f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29600ce72daca1c0fad79e0ef748285d172e4f7bd7de928b1ae77eb1b3f4454"
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
