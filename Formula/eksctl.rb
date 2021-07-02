class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.55.0",
      revision: "e9a7a37b078c556dc3dd2b13f012deabfcc9f685"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d41988acf275b74c60bbab2ca669cf582bafb310775e91458294e5dc761ec5c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d727c355d4cb75f587cbf18348d158776f544b92b74efa82910081290dc5870"
    sha256 cellar: :any_skip_relocation, catalina:      "07e1b10a3e9f852255d4da15143949274ac393b1cd584476fe32148dedf70313"
    sha256 cellar: :any_skip_relocation, mojave:        "64bb635a6dbc461bd34d7ab52b622f2a0db94819bfc29166c71977e09d1f87ae"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    bash_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "fish")
    (zsh_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
