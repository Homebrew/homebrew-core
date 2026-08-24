class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "b19deba3f8cf3eb05407aa85c246e22839770c437439a04d880ef3d645aed0aa"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c1b4ef286ee0d753034292621e8f39ef778666352405c7aa69fec9a2bec1fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c1b4ef286ee0d753034292621e8f39ef778666352405c7aa69fec9a2bec1fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c1b4ef286ee0d753034292621e8f39ef778666352405c7aa69fec9a2bec1fbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7840db5e8c3ab7db1f47b4f97e429962634ced59744d39c8aa7ee77b3eb4ee00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cb519ce033db8bbeb780068a54b864887105b09915dcccf5524fe72d0e6ab12"
    sha256 cellar: :any,                 x86_64_linux:  "4a1341a195baffd1012e6724d6ce828b37f398d7bb81ea7223a243a7871bb599"
  end

  depends_on "go" => :build

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install buildkitd
      EOS
    end
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
