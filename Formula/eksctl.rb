class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.108.0",
      revision: "728d4ad1a78bc76599cc447adb1510b66ae2dbe8"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccc8a0eb02cf4e57e92f39c8bdfe763ee12ac83054f41e68dca432b861cdd9fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6c701c8f7464837df347b3e9b50007d03b05d202fa08d7882203ed56aaabee2"
    sha256 cellar: :any_skip_relocation, monterey:       "bb0a490e47052066cf077e283798ba981811442fa05faafec4b7c65b39e26e16"
    sha256 cellar: :any_skip_relocation, big_sur:        "753c90586892e3f0a383bc00f0b13279fa916828e140c4c57850b4cac05a51df"
    sha256 cellar: :any_skip_relocation, catalina:       "0caefa4bd592730294d9903359c2a763ac4cad3d986d8e8018ee3914a5f310a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaca5bb95783d0f7af51b734ff3a6dc700139e96e3fef9db780bde50bb590d1d"
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
