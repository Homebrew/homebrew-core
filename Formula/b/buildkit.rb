class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.34.2.tar.gz"
  sha256 "e9d5867e1f973ff13f46509172cbdb22c3acf8f1867215bab31d95d37d67964d"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b866c28e0fdcab88290f879fcaea334983bf60cc1786cfe4ea1b2f57e48d1d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3b866c28e0fdcab88290f879fcaea334983bf60cc1786cfe4ea1b2f57e48d1d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b866c28e0fdcab88290f879fcaea334983bf60cc1786cfe4ea1b2f57e48d1d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9b49bc534a5bda2db7c8f4e6e647b23e322b6c4ce5bfc8a8e481c6969baeceaa"
    sha256 cellar: :any,                 x86_64_linux:      "b5bae3c40998cc125f89749f0a4f7606a98f66b33094c3f42a23960cd80c7b26"
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
