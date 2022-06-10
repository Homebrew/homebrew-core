class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.101.0",
      revision: "b7b23655e5f73cf049c1467c05836b711af16163"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52387a5b0948e29da822421c2762a047fc9658c4b5e6b8213493e4494e3737fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9753ad3b96f0e679ae832f390dfc9b4593e72d9cfdb27b0887b0356e8c0505c5"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf7de283feec1d09e269ce6c8104adbb7a8dc931e3ee5823e0a8a7b714476f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa6a4b7b160acab164ea4ff97683d216405ab0d02a31bcf234ee834a41935cb5"
    sha256 cellar: :any_skip_relocation, catalina:       "87784ca120622a617f9b0489ed8d5fa8c335606a511a49d3b0a0bc09c8915cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4af8fd6c58e369fdb8d92c71d4487c77e8e6a7759a1ba66305e343948b69aec4"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    bash_output = Utils.safe_popen_read(bin/"eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"eksctl", "completion", "fish")
    (fish_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
