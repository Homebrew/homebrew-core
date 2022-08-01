class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.107.0",
      revision: "b204c3ce61a2fa388a7930963d48ca880b009b38"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5acb7d1670b37bd5d53d09898efc4ac8242a8627c0a30323bb265eaee4aa164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16d88132a5e447fc03c2f5c7501da3dc4622adfde9616ca1878e9f1d31215163"
    sha256 cellar: :any_skip_relocation, monterey:       "4bc7f3d779e541fdcdb291598ff8f5c8cacc3b2ca8ddca79d4b232dff7b077dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d1e9fe6c3674b0d5dc4d76135b9d75f23b4eeaff8884fa6c0db7d393401d2c"
    sha256 cellar: :any_skip_relocation, catalina:       "1d9071d734bc86067d46661bead2860328a561ae5097680ec19059bc2f478527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d3340652104bfcc0f256058ba06ef34979a519cea509d4bc3d30c9766490126"
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
