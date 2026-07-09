class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "b733b9243017cb2b8f9cb1a6bd5125a2bde5680d4063412dbc159402bffbaf1e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df5e13bded0c23cf3345bff52e02b7bc95a532543be47c3b071610c37551d7b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df5e13bded0c23cf3345bff52e02b7bc95a532543be47c3b071610c37551d7b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df5e13bded0c23cf3345bff52e02b7bc95a532543be47c3b071610c37551d7b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a01394136d5f00db467f0d352b13e649b3fe89f408b5799e6fe8d5295e0f7bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3f3513f354fe1f6d6269480a67547131841b0fcbcf4998769c06b74f3f7357b"
    sha256 cellar: :any,                 x86_64_linux:  "a980dfb7e036bbd768ecc79aecf074898e791a58e524ab6baa36264a95f5a862"
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
