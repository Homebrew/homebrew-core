class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "0f7d4a765b273359d0752aa1c8a309606578fd0db42e71f0fc5de845d3b1139b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0722324f498a0036b58d7ff0a5e9f006b701aa124b79ac4022926dd7047c227"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0722324f498a0036b58d7ff0a5e9f006b701aa124b79ac4022926dd7047c227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0722324f498a0036b58d7ff0a5e9f006b701aa124b79ac4022926dd7047c227"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39a5741a214f732b1b18ce4a83de432e124b434feff955c4f1d8cf9bb77019e9"
    sha256 cellar: :any,                 x86_64_linux:      "2b334440734d40124d27f34904aff8d6f1fefd232fc2c60bd116c1d3a42ec361"
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
