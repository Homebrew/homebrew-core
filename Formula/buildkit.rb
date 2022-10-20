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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdd08ad3e820721cc15dd1afa38068a4d43560f7df6f40298a9047e075dbdc95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52f86fa598ac4058caf82d1b033a7831655ac101419bc0678128d263919c7dcb"
    sha256 cellar: :any_skip_relocation, monterey:       "c1101d1069b6b871584fb12b6e6bc800f17da07a8d450f7fa2ab3be09ff6ca34"
    sha256 cellar: :any_skip_relocation, big_sur:        "954ec9bc5ef741fff9fcdbbebc528285d62fb11341def6a003d2278680d9becc"
    sha256 cellar: :any_skip_relocation, catalina:       "a7e84c9a3ca40c97c771e92eb260a7526881effa4d319c5d03850923185a6f4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129750e3341a815e286b96716b6a274958d2fcba2cf6b97c2de2d805f34b79c2"
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
