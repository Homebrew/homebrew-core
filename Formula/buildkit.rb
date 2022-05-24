class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.10.3",
      revision: "c8d25d9a103b70dc300a4fd55e7e576472284e31"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ca4cb92d901ac8ccbcadf27a2ec7aba789816346a99ca68f8700bb21150da70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2cb56f1d346308e379052a3d02d2d9123d07068d97bacb25763d0830186d3eb"
    sha256 cellar: :any_skip_relocation, monterey:       "e9b62fcea0f70acabdaf22a63c4bbc655653a418e8eaee037ab446990e1f0721"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d2ee0328e9b27729d7e00e659ab64edbd4ae972376c9775eee18dc9a4fcedd7"
    sha256 cellar: :any_skip_relocation, catalina:       "d3916f6b179834f2ba3df2dbc0bece7a1e901da24530e6d4688644688281e45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40f9e1372206c7663c8806406f88028036b19c0320ec0ff806e2d93fca0d37eb"
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
