class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "ad9726b3270d3c9a4ff16389d527a0ee441880f3dfcf7e52b5e5ce87da7b8b61"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db56300770288b736a4acefb4b5a2b76411577b0e6c65b0737b479e5fcc4e580"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db56300770288b736a4acefb4b5a2b76411577b0e6c65b0737b479e5fcc4e580"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db56300770288b736a4acefb4b5a2b76411577b0e6c65b0737b479e5fcc4e580"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99bac6f9ddf98d32f7d6f8af2e8888f5462cf4c4dca5706f693fe98ce0b3ae6f"
    sha256 cellar: :any,                 x86_64_linux:      "f27e099b38ff3160b9e6c086793b0007b1098a32fd0b876589440496b9c5c0de"
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
