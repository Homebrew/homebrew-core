class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.17.3",
      revision: "5eb50600d9c2c02b49dfff80d44f93be4eeddaae"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af12394d47dcd73a6e5cd3fcfb6e9a2b936e605f72347532d79d4a5fc1b741bd"
    sha256 cellar: :any_skip_relocation, big_sur:       "14feec9cefc814480016b604104300eb3f56c0177872023511b0e5d740d9898a"
    sha256 cellar: :any_skip_relocation, catalina:      "7b7d6343a421866de4f31635cdf571a50a3698e413942394c0e012ae6ee8d3e9"
    sha256 cellar: :any_skip_relocation, mojave:        "dc7de61932acd84ddf7903b2748c5a75ff7ee422972cc6b2c5e6bb4e11588113"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
    system "go", "build", *std_go_args,
                          "-ldflags", "-X #{commands}.VERSION=#{version} " \
                                      "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
                                      "-s -w",
                          "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
