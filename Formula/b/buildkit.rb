class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.21.0",
      revision: "52b004d2afe20c5c80967cc1784e718b52d69dae"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed500c9a1385bccdddf4a0e23bf1d027a4254e7169cd7867d77449577fd3862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed500c9a1385bccdddf4a0e23bf1d027a4254e7169cd7867d77449577fd3862"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eed500c9a1385bccdddf4a0e23bf1d027a4254e7169cd7867d77449577fd3862"
    sha256 cellar: :any_skip_relocation, sonoma:        "16b99aafcffecd099be6df8ccbc85a13e2b699c2cdf1f5582eb4582f1426fee7"
    sha256 cellar: :any_skip_relocation, ventura:       "16b99aafcffecd099be6df8ccbc85a13e2b699c2cdf1f5582eb4582f1426fee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9021ea6fa09e77e05bdeadfb8a34d8146db2ee2fb75fbac08059e54496535ea"
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
