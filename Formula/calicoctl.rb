class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.17.3",
      revision: "5eb50600d9c2c02b49dfff80d44f93be4eeddaae"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "acedc9044e69177aab993b10194ce29c75240869bf304da103ddb2b235f8222b"
    sha256 cellar: :any_skip_relocation, big_sur:       "eeff2f7bdaf740c5da2a23d94200a063c69a9a6a5a5f1777e98fb3f268179695"
    sha256 cellar: :any_skip_relocation, catalina:      "4c9a44b7ee7f48521996da4d53de7825caba61b999bde46745abe5f653414cac"
    sha256 cellar: :any_skip_relocation, mojave:        "582f638600ab7ace6f6c234f03b6dff3da91f617a41a83159d403efec04b8b8f"
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
