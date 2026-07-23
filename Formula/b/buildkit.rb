class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "3085082772044c5cf0431d969603618ff7519d6c82dc1fe19ae83803d8973aa1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "341196c1e5eac9b7fc6478dffe17bb38c707f66f73445994c9e4b7401529bf52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "341196c1e5eac9b7fc6478dffe17bb38c707f66f73445994c9e4b7401529bf52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "341196c1e5eac9b7fc6478dffe17bb38c707f66f73445994c9e4b7401529bf52"
    sha256 cellar: :any_skip_relocation, sonoma:        "1921ac8803858531fcbd040e057fb05d127fa846e6a1714756d1c96c15cd37ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e3e4eb88a2cb74cb5a01d304e44a1752386f632967cfa8d5e91bc67fbfed64"
    sha256 cellar: :any,                 x86_64_linux:  "85455e8db2a15407e0faf9128b4231e3bb31ec6833ceb4b7dbbe1fafdaa6f57b"
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
