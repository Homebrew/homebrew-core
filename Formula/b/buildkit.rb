class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "d7ec8c8657ad0c8b1b29219d923afb693b3a6321748aac034c3afee2973b07c8"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49ec7ddcc7216653ea942ddf701c42b5cd09f7fb87955b954dfa6b6544dc7786"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49ec7ddcc7216653ea942ddf701c42b5cd09f7fb87955b954dfa6b6544dc7786"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49ec7ddcc7216653ea942ddf701c42b5cd09f7fb87955b954dfa6b6544dc7786"
    sha256 cellar: :any_skip_relocation, sonoma:        "c32d0f1e65034a50ef3f0a459b67ebf1030289558951108b372a07ac46d46794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbd9164c4d45094907b7d08c19f2a142c58edd8fb6898e99a01f688ad6e4c1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a42e5befe30d2dac8ae36bf18040d75ffdbdee846e17b75c075d5d65d5fea08b"
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
