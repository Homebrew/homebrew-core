class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.24.0",
      revision: "b772c318368090fb2ffc9c0fed92e0a35bf82389"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c76d4fa977da6189445dff9edf3355913de0283059a81225edeb8f007fb0f775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da1e9b6d016ff076cb7afe06129279dc874f8e98e04a44ccb1f8d6fed6a57144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da1e9b6d016ff076cb7afe06129279dc874f8e98e04a44ccb1f8d6fed6a57144"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da1e9b6d016ff076cb7afe06129279dc874f8e98e04a44ccb1f8d6fed6a57144"
    sha256 cellar: :any_skip_relocation, sonoma:        "50a9784b0b7f5ebe2684cac80f2ae96eb1db2be366fa88ebeb3efc443d766a68"
    sha256 cellar: :any_skip_relocation, ventura:       "50a9784b0b7f5ebe2684cac80f2ae96eb1db2be366fa88ebeb3efc443d766a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be09ce13fc8883a4d25f45a08a7e79af703d5c9b559e9b410448a9974ead2578"
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
