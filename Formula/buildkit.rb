class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.11.5",
      revision: "252ae63bcf2a9b62777add4838df5a257b86e991"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99b9909f093a656f5ea9fcc00fb0d8627fef0c10ecc61b84902f4673c6960f52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99b9909f093a656f5ea9fcc00fb0d8627fef0c10ecc61b84902f4673c6960f52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99b9909f093a656f5ea9fcc00fb0d8627fef0c10ecc61b84902f4673c6960f52"
    sha256 cellar: :any_skip_relocation, ventura:        "bd710bcb7ccab3df54efa40341e12a95a88d6f28ae9548afacdec57df9c4b67c"
    sha256 cellar: :any_skip_relocation, monterey:       "bd710bcb7ccab3df54efa40341e12a95a88d6f28ae9548afacdec57df9c4b67c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd710bcb7ccab3df54efa40341e12a95a88d6f28ae9548afacdec57df9c4b67c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14009ee7878fab711c2346dc055bbfa61f302ca5313462106d12c4d15f306126"
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

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
