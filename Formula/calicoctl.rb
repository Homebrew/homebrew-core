class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.18.0",
      revision: "5d65da3dc6943cb0d7909ad2865ce8224caf1cd9"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "960730dc92b9e23bcbb84e17e427d533e461b0cbdd676b744f95f3e01c52fbba"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a994ece9f2edb9b55cea66e93f972d8ffdd764922b51699dd213f9fc926a8a9"
    sha256 cellar: :any_skip_relocation, catalina:      "c62191885f6f41e599abfae8aaa553605c98998111081d950aaafcedbe7512c6"
    sha256 cellar: :any_skip_relocation, mojave:        "454e373cd11cd91339fb6d3dbad4ae9383f4a92f6656f42778464d31bd114464"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/v3/calicoctl/commands"
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
