class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.16.2",
      revision: "86622bb0ca9cddc55e7f3c623099a07c53a6251d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8920aea8fa8619fca97f3fcc295ab6b5855582d639f361191aecb0d79c84f61c" => :catalina
    sha256 "943adb8672eb263d61631f3689bd5b909b30a04d6e50bad5a028f7ea7b98720a" => :mojave
    sha256 "3a5ff0f4d05b17e858bbb303ea0e643ab2e0b53c5a2bdc0ee1ab40a04a5d04e1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/calicoctl/commands"
    system "go", "build", *std_go_args,
                          "-ldflags", "-X #{commands}.VERSION=#{stable.specs[:tag]} " \
                                      "-X #{commands}.GIT_REVISION=#{stable.specs[:revision][0, 8]} " \
                                      "-s -w",
                          "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
