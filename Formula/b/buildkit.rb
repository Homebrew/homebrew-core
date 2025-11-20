class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.26.2",
      revision: "be1f38efe73c6a93cc429a0488ad6e1db663398c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd4c5a47a3740d585955ef9bd8907bd3bce0c2138338cc3aa61a185e91fa5aff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd4c5a47a3740d585955ef9bd8907bd3bce0c2138338cc3aa61a185e91fa5aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd4c5a47a3740d585955ef9bd8907bd3bce0c2138338cc3aa61a185e91fa5aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "28ed5b0cbc47c006a38d78c5c9adf0ed6219a69d3cc437fac79071c20030a896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae8f9ed36659e3b9852424c9db358c19759b85ad5758af3c59a9387a7cf7040b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d318216ca523331c66e0076b58ff6e938a9472942f2b2932991a28cf80bdf02"
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
