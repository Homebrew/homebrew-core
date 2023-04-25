class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.11.6",
      revision: "2951a28cd7085eb18979b1f710678623d94ed578"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da99c87850e299de30ad3686da9cfe59a916e4029bfee4d1333bb550fc56d76d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da99c87850e299de30ad3686da9cfe59a916e4029bfee4d1333bb550fc56d76d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da99c87850e299de30ad3686da9cfe59a916e4029bfee4d1333bb550fc56d76d"
    sha256 cellar: :any_skip_relocation, ventura:        "f5c5ef577c6760efaa04da2cb535d30f69f6e39bb4fb43b4500916c5eceae3df"
    sha256 cellar: :any_skip_relocation, monterey:       "f5c5ef577c6760efaa04da2cb535d30f69f6e39bb4fb43b4500916c5eceae3df"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5c5ef577c6760efaa04da2cb535d30f69f6e39bb4fb43b4500916c5eceae3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae38981eecb4ac8eb509b5c6ae0c957c71c1c022ba02507274bce135553fabb"
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
