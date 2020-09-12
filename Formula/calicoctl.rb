class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.16.1",
      revision: "7426fc4418468f613c00c04dde4e02d8bef32257"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1df2ad963de09836719e79e2d78fc0e0095e15bbf4f3e147571e4e9e1f6d8cb" => :catalina
    sha256 "60b5eae62f470a37ca81d5860b022cf55d1b9ecddd2cdc2e883f8fa60ccf58ed" => :mojave
    sha256 "271b944e8db94420ebf62c7888869b2f5983be1163fe6c86fcf716c03e8a6192" => :high_sierra
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
