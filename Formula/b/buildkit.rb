class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.21.1",
      revision: "66735c67040bc80e6ed104f451683e094030a4e1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731554175e0f92a73a1ac88f324089e3db7bb869d8dc8aaa7a133e97ad8c9224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731554175e0f92a73a1ac88f324089e3db7bb869d8dc8aaa7a133e97ad8c9224"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "731554175e0f92a73a1ac88f324089e3db7bb869d8dc8aaa7a133e97ad8c9224"
    sha256 cellar: :any_skip_relocation, sonoma:        "727039dd62444969ecbcc39b73e8c4fd3776e95f8124dfc4a42c98934391ae01"
    sha256 cellar: :any_skip_relocation, ventura:       "727039dd62444969ecbcc39b73e8c4fd3776e95f8124dfc4a42c98934391ae01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433a2fc97d48936e550a4851422676ed470c4c400f1e836fbe5e1235313f8165"
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
