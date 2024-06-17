class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.28.0",
      revision: "413e6f5593a8e76d34cf5338a642265da52561ce"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97ee1615d709abe783ecc8fb0fda669303a2eb562d771df7b95204cc567a5736"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28dbd50a5d4146ce5029233c505c63dffd633ae4f6518bfb2892acfc8fb0680"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7b3db812d2f2af9d5e06b7cbb85dfc654a714ad9f84cc3bdcb21bf723eda50e"
    sha256 cellar: :any_skip_relocation, sonoma:         "351c7cd413dae192acd65e449ec9e9b1185796e8738acf4da98a28fea0c487f8"
    sha256 cellar: :any_skip_relocation, ventura:        "d62d02031c7d5510a3120f6a23a7138884f42c1b54e6d955aed5eb96757357e8"
    sha256 cellar: :any_skip_relocation, monterey:       "039ec3f19999ec3f74fbce2af97a9969ad272495f5be936ebd425405b8f415a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "496f2d44b38195d96f0bbcf85c385ae4a8724824f98bca0fb66f505d99a50892"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
