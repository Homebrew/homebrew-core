class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.101.0",
      revision: "b7b23655e5f73cf049c1467c05836b711af16163"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da2ef06ac12f20eadc6bdf792c76e993bd7987d4b797dcce3fa48ed8ecb7e77d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8327ac90a7761c862ca679724e946cca195298d1a496b1d36bd69b0474ba4e27"
    sha256 cellar: :any_skip_relocation, monterey:       "ff731fc1e912a2579abce034f23ab7bc421b96de74ab4aca9f0ae8207dc54eae"
    sha256 cellar: :any_skip_relocation, big_sur:        "1407dbafe0aadc45d3ab1697d1fb2a0a1324d4bd1a00c6bc958a6387ac7276d6"
    sha256 cellar: :any_skip_relocation, catalina:       "35f845aae855db6f32a391fa545b2fab5e4a41d366c09b00b216b433e3908cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d123d046da89c5777e52e5a5f8c384448b1be8d867281964534b4f10dcae122f"
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
