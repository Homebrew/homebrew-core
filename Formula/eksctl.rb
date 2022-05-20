class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.97.0",
      revision: "0ea20abd3da771aa55a9ce15e94859c81c052ae8"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7bda40c289b14afa8dcdd1bf492d6615ab8e1a575017daea053bd09743c065"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b306cd8b538261113a73bcb900c70564a640be61bc2b3ca491e34d27dd892d0"
    sha256 cellar: :any_skip_relocation, monterey:       "f8cd1b41fd785f33bde5cb42edc8a34b6b02aa540bc4ea5f879ee76627d12862"
    sha256 cellar: :any_skip_relocation, big_sur:        "71efe19eb201253a76672ad222a06c9c0f5c95f1a0f976a7136d220f0268bcca"
    sha256 cellar: :any_skip_relocation, catalina:       "9282a747564d1ba2555ec7d5437c384fcb7ef6eadf5cc2423bf3f056d597ac36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c88f742c142cb2a7818509f5046021c78a4e3b55a03e5872d5306cf11d5e1169"
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
