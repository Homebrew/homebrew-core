class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "243d6ba77404467f90087a9141af5f755f1e8aa22d4b4c42ce87a1b898d9b8b2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c492b3bf97ca06eef9c819666d7fbde8324bae6136f8ba3f2ac3fb00e007b9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c492b3bf97ca06eef9c819666d7fbde8324bae6136f8ba3f2ac3fb00e007b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c492b3bf97ca06eef9c819666d7fbde8324bae6136f8ba3f2ac3fb00e007b9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e60a0c9632851032515b2999f1c7b04ccc9f9ef331b4fbcb9247409c5493b580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4591d6f13f8f26b1f472571407f148af1b74d80515ee880b221d4d3e1cf06e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbdbb8f26b8233e09a23bfcd1ff1f233aa4835b36cafa44120c9a4e30053a511"
  end

  depends_on "go" => :build

  def install
    revision = build.head? ? Utils.git_short_head : tap.user
    ldflags = %W[
      -s -w
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
