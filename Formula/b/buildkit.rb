class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "214dadc2fd4730171f7d3be2c96c80d063e943d5cba84e34d803d3ebd37b4fb3"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba0b7082f60b5d4a3b6c0110b4f32bf9822a3afcbf4aaa2a9c6170853f32dee2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba0b7082f60b5d4a3b6c0110b4f32bf9822a3afcbf4aaa2a9c6170853f32dee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba0b7082f60b5d4a3b6c0110b4f32bf9822a3afcbf4aaa2a9c6170853f32dee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d7eaab316f9bbd62c077e8978c120f8c0617ce78e7601b30a132be07a757847"
    sha256 cellar: :any,                 x86_64_linux:      "f12c75bc11ba2e193538f8c45a6f96a347c7c599d4f225f3b2921dae013d5bb7"
  end

  depends_on "go" => :build

  deny_network_access!

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
