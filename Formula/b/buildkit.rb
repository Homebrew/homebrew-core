class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "2307112b30593fb8fc4d479ce4547862fa101fa2ecd50a852330a1117a988bbc"
  license "Apache-2.0"
  revision 1
  head "https://github.com/moby/buildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "291782fc68044e422d0c4dc0e1bf7005c66297326ac90ac1fc508020afcec954"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "291782fc68044e422d0c4dc0e1bf7005c66297326ac90ac1fc508020afcec954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291782fc68044e422d0c4dc0e1bf7005c66297326ac90ac1fc508020afcec954"
    sha256 cellar: :any_skip_relocation, sonoma:        "06f4e670c424cb24ad8e542c716c79e606bedf12eab1c14b7a63ac3a26d24cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa8554e9920aac8c31e479041070e2a85d00be0befec14442d72d6fac62aa9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "254f4519fce6bcff1fa1c08d8165c3d88140f1615ad4402076ebf10a568bffba"
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
