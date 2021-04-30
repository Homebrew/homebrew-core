class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.8.3",
      revision: "81c2cbd8a418918d62b71e347a00034189eea455"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "481ce58bfba185e6614761e4db47cfd5bad298c7d1befcda37a38ed88c98e2b0"
    sha256 cellar: :any_skip_relocation, big_sur:       "f0136996daa0dba57602f1cd2a662c21e24927feb758b3269c2be81533b87453"
    sha256 cellar: :any_skip_relocation, catalina:      "b425bf61e8799358958db28a875f16069f5278d066f934c624bec1ace320a24e"
    sha256 cellar: :any_skip_relocation, mojave:        "04805349df94e16f5cb3e59e14c2bdd29d8b72b266ee11119934a677b521e068"
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
