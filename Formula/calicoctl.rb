class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.16.5",
      revision: "a9f09ac323d796de731f2fcdefc3b605ee41242e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3698ba2efd7556e7387c796732cea0f25a43a8d11763505ee208d8787ca72738" => :catalina
    sha256 "043f0c2660efc68aaa5e71867f57033f21d7dae59b37a87553c2a22b38c2531b" => :mojave
    sha256 "bca2644f2894beb58e5c65462894845a3483cce49d175e1341f1b7f7c1ac6b58" => :high_sierra
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
