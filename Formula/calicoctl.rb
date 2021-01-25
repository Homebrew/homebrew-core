class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.17.1",
      revision: "8871aca3dc0b30d6143031e46498b648e153da2a"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ab5678c0037e96ba8efca1d2fad58a4051e6d9bb1b8cd48f7b149f8c12380b4" => :big_sur
    sha256 "46dcad8fbdb7468ff86e47af5382dcb33a0c581d8e2521b13568f7d28cfd6376" => :arm64_big_sur
    sha256 "bcc50b0b86619b2ac9a459d86f726e3595e9afd37e175d2d63edee8b402a2139" => :catalina
    sha256 "b01d4c3fd2b8a6cf486dc98fbd9a7cca41ee2843a1f07ffdbfc1a24d73e0a6f8" => :mojave
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
