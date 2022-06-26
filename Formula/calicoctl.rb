class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.23.2",
      revision: "a52cb86dbaad269c80cbb7d7f17ec9c829e34a8d"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a183a84f75d5c8062fc9777b75ee866692a3c867d2395ad72953721164c0f49a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32bc874c2e38805dbd7830481ec654002fd9ea5d3c84a3421d2705dffe19c23f"
    sha256 cellar: :any_skip_relocation, monterey:       "b30c48ca40b572a1a88009605a9fb85438e73347519dec02d889a6e91af2638b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4aa8d9a41b4677e9c13257e20885fe49fc40518615686dbf2978759c07cbc9ac"
    sha256 cellar: :any_skip_relocation, catalina:       "db2e9e2757cde5bbd970dba95af48b28c2e05f5ace5cdd9d9a0931d072975546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "234b5452948de1d5140936996e21dd500497d6c30763027fb92c721f070c2bfc"
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
