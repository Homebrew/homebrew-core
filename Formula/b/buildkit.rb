class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.12.2",
      revision: "567a99433ca23402d5e9b9f9124005d2e59b8861"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "500fe40cdcce31cbf21535ab05e003761ba08f132a1c362dec54b0caceefcb15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4987f900592e7a1ec14d37ab4b9debccc8818d028b87bc31ab725df027ca785"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b687eda8fb6dea4f9188eeaef2c18b965f328c0f3019fd6be0d1361f74093069"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ae58060e07743eaa242105e78b50680bc725d53283f0743b268dbd4e86c75fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "1bc83bf2bb6f98933c6619feaa38a81224b564197f2be8b266b3fd3594465564"
    sha256 cellar: :any_skip_relocation, ventura:        "037ccce551a05152f4afd80eb7c45f16c1f240d514da71344eebd9fd2e10a803"
    sha256 cellar: :any_skip_relocation, monterey:       "85da2048ffeeb2bbb91b89b3adcf3900ef7b86be5134e8e4bae058e5c534eb33"
    sha256 cellar: :any_skip_relocation, big_sur:        "f61e1c2ec33e7a6f9d766f58555ba6e65025750820b16075fb53ef7a139406cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f74eb225de3f4dcab3f18782bebdeaffd7d413abd80c179678b86568891287"
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
