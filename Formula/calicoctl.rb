class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.16.3",
      revision: "7d066703e136723c29cebe5e7a82399bd624d226"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4fe349ec4e7531efdfe913bec603c369232c0842eb2aaca1727387deed54a23" => :catalina
    sha256 "9a23856f66ba7c3df86da13fead3600eb86602037aa73b19a7c01274d425677d" => :mojave
    sha256 "de7fa06489534de39c3d2aa6583240852b071b7094f9b83107dd62966d5a2616" => :high_sierra
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
