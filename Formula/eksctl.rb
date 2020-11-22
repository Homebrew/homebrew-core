class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.32.0",
      revision: "41d40c256b68823f42a8c71cce7a2eb4d6236ce7"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67f499018779d7f254e6978f573d2f79a6bb13c18f8e72216098eed2d7ed0702" => :big_sur
    sha256 "bfa7b2fc15af7343dd31670c916c470b5df4bb26b60f7991c938ae730ffa24a4" => :catalina
    sha256 "79ff3528842b4d602d7ce5195d698cdbe498acb98d550fd8946ae7adb687d434" => :mojave
    sha256 "b4fe067b46ba355b075aad0891df35baefcaf276dcf0243d09ac780000b0a1c8" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
