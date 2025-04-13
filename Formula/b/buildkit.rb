class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.20.2",
      revision: "97437fdd7e32f29bb80288d800cd4ffcb34e1c15"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e52a11fdb07880891c09bb1ba203834618fc32dfbf715085f79a0cc6f2a1ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e52a11fdb07880891c09bb1ba203834618fc32dfbf715085f79a0cc6f2a1ec9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e52a11fdb07880891c09bb1ba203834618fc32dfbf715085f79a0cc6f2a1ec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a55f1100ae0bd6ca69b01e27dea225a42e07ac8d9a5467d8d717fbbf70a6e98e"
    sha256 cellar: :any_skip_relocation, ventura:       "a55f1100ae0bd6ca69b01e27dea225a42e07ac8d9a5467d8d717fbbf70a6e98e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c499502b870a07bbff2db694d97b5f6c52d3019441416e4c323bfea39f4f5bd4"
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
