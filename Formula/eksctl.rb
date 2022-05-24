class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.98.0",
      revision: "8351f23ecf8ee3a4deb2b61fea005d5821a7315e"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84773863384d17fe31f84447e0490fbd6adedb8f8f62b15889acd86fa71bbf44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "173b124b9be02143ff7ab645440f1174cecf082d465e02e4785879452b947997"
    sha256 cellar: :any_skip_relocation, monterey:       "b28e413713438fa0774f0a1f518d3f2bd44e2e0070cf181c11a4fd4f68ea4efd"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf31a36631e8aaf6f4fc8045fcdc96a02eead523553262dee91bc619ac10c5bc"
    sha256 cellar: :any_skip_relocation, catalina:       "91f7ab4e04156e8f8ecbc7fccae604752c030569512211a8ce65f4c2343d09d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a04706bbd0693236c1797b8a8112a0c42cd63a5537bdd01f18477e7e0df1e74"
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
