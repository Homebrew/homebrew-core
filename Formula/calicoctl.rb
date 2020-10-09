class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.16.3",
      revision: "7d066703e136723c29cebe5e7a82399bd624d226"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "85305bb4eff9d57eb45ecde70184ad19284b9962c2bf83cf88846e68f7cd88a7" => :catalina
    sha256 "c2eee260db756c49985c3e26d35a1a5303e7a2918cf3bebe0805d24f53bbc9e2" => :mojave
    sha256 "133552728e54c9853dca70a88d2c7c648f5ed5f35a59f5ca9ef8dff8db6f8274" => :high_sierra
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
