class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.10.5",
      revision: "bc26045116045516ff2427201abd299043eaf8f7"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baf2aa4ea607ed5d91a41ef62d348f5aea8a47fd785b1e8a596179637a3c290f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db08c5dfb9b733616b60c4a28c5ba50244141f614365852769372e596b8e1deb"
    sha256 cellar: :any_skip_relocation, monterey:       "98219804faec1587b401167aaf1d57cbbd132004140e2c762088e15998547cbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf9cdf0973ece6feb421909a5dc70c247c8a7e1e7e2aec72c8ff0fdc5f4de959"
    sha256 cellar: :any_skip_relocation, catalina:       "29ac9c68059c58114fca3266b5e98d5744e522f2ae90255680ddf8ab028fae6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f38699047547f1a4d0cbb68b79e243653053efdc48588362e14268c054b6b6"
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

    system "go", "build", "-mod=vendor", "-trimpath",
      "-ldflags", ldflags.join(" "), "-o", bin/"buildctl", "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)
  end
end
