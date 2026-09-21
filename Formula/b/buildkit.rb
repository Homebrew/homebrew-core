class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "c365476e1b10e27a2ab809e3a7a6dcd0647a60fa6e8917799b894d4127af7306"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca2eca5d1ea6c115a1494155f842b92dfe744bdda681f4311b46f99e25a8e753"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca2eca5d1ea6c115a1494155f842b92dfe744bdda681f4311b46f99e25a8e753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca2eca5d1ea6c115a1494155f842b92dfe744bdda681f4311b46f99e25a8e753"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ca2eca5d1ea6c115a1494155f842b92dfe744bdda681f4311b46f99e25a8e753"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cadc0c70cef2471e1e27eba8106c7a69853ea8d71d7ecc621609abf4dea708ad"
    sha256 cellar: :any,                 x86_64_linux:      "3a80704b804aae9cee4426a02eafd58bb9264dd96d89e914a0ae56d47a0009a4"
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
