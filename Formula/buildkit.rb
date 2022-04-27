class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.10.2",
      revision: "9d2c9b25145ff021f91374408be710938297ba24"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "593b05d049d4587bac60785ae7cb08def77edac292a682daa78bc7ac37cd1f73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b242b95c6416ca9138f82330ce4514087f4ee225d6d10c54aaab862870cf007"
    sha256 cellar: :any_skip_relocation, monterey:       "efde4e28e385ca53955c7ca38fec7c80d370b65fcf3f1ba5a8ef2f04eaace0f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b346e8e395e6150e699c6b417a1ce260616ac384ec8948dfb2989b771afdbd32"
    sha256 cellar: :any_skip_relocation, catalina:       "27ee2e35147a02f70da26d4c283efe17cab2dd49970a7cbacefe3affb702c5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f5ccda44dbe63c90f6eb513e2cd222a9e315d5a846ba3b0bb9b239cab042780"
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
