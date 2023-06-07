class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.26.0",
      revision: "8b103f46fbdc989e59d81e08d215ab4a59fa6cec"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4aa4cb5c5bc7305b6a5f0bf934fd9b25204e704619a852bdd4dfc8f5df10c125"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa4cb5c5bc7305b6a5f0bf934fd9b25204e704619a852bdd4dfc8f5df10c125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4aa4cb5c5bc7305b6a5f0bf934fd9b25204e704619a852bdd4dfc8f5df10c125"
    sha256 cellar: :any_skip_relocation, ventura:        "67e656fe743618426c69dc24149c8cb50e7a5cf65d03d498a28774bb7bbe9241"
    sha256 cellar: :any_skip_relocation, monterey:       "67e656fe743618426c69dc24149c8cb50e7a5cf65d03d498a28774bb7bbe9241"
    sha256 cellar: :any_skip_relocation, big_sur:        "67e656fe743618426c69dc24149c8cb50e7a5cf65d03d498a28774bb7bbe9241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802f17470bcef0c280ce25da13950b8bc540093895e8a3c2eae8792e599f0c9b"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
