class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.16.0",
      revision: "0865fcc9b78559e856e81dc52b3613701e7be28d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d6fad2119262f3f0247f4227253355f8c8c108faf1ff51cf2556c619d9c97522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6fad2119262f3f0247f4227253355f8c8c108faf1ff51cf2556c619d9c97522"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6fad2119262f3f0247f4227253355f8c8c108faf1ff51cf2556c619d9c97522"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6fad2119262f3f0247f4227253355f8c8c108faf1ff51cf2556c619d9c97522"
    sha256 cellar: :any_skip_relocation, sonoma:         "72e464e9d792f003e6793dacb497aab549910cff6ead6877a4ff80df637f67a4"
    sha256 cellar: :any_skip_relocation, ventura:        "72e464e9d792f003e6793dacb497aab549910cff6ead6877a4ff80df637f67a4"
    sha256 cellar: :any_skip_relocation, monterey:       "72e464e9d792f003e6793dacb497aab549910cff6ead6877a4ff80df637f67a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae6bbcc850e7d64d7446e7cc9f33250b4ab84bc82db2c3b606be60f8443a658e"
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
