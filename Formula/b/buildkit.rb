class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.19.0",
      revision: "3637d1b15a13fc3cdd0c16fcf3be0845ae68f53d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0eaa29720f2ecd1020fe24f6b2c5696ed347d53dac30eeac65792b7897a455d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0eaa29720f2ecd1020fe24f6b2c5696ed347d53dac30eeac65792b7897a455d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0eaa29720f2ecd1020fe24f6b2c5696ed347d53dac30eeac65792b7897a455d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4abf64ac2643c26fe36f7a9d51422aba25bb16ca3137d5c6a9545a3a69815a3"
    sha256 cellar: :any_skip_relocation, ventura:       "c4abf64ac2643c26fe36f7a9d51422aba25bb16ca3137d5c6a9545a3a69815a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08872cb771fd61f37141a07b1edbe351cc202d824603e6648148690981fa8114"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
