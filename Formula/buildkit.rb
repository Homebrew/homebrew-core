class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.11.4",
      revision: "3abd1ef0c195cdc078d1657cb50f62a2cdc26f8f"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f21f9ff1a3bf343b9ebec1cdf6a111cc17b36a4fe451b26786865fc682ea19cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f21f9ff1a3bf343b9ebec1cdf6a111cc17b36a4fe451b26786865fc682ea19cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f21f9ff1a3bf343b9ebec1cdf6a111cc17b36a4fe451b26786865fc682ea19cb"
    sha256 cellar: :any_skip_relocation, ventura:        "794f8dd11e148242ca4bf6275f681ca2dfff006e76741d30f4da8429f37125a8"
    sha256 cellar: :any_skip_relocation, monterey:       "794f8dd11e148242ca4bf6275f681ca2dfff006e76741d30f4da8429f37125a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "794f8dd11e148242ca4bf6275f681ca2dfff006e76741d30f4da8429f37125a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fecb92bc377c08629f827736436248ae33a6c5bdb5cc05d455fe19e090033c70"
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
