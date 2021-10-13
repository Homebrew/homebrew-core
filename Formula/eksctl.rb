class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.69.0",
      revision: "38a4ea97eeae6ad31f549af827a4f6ceb868381f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f56f08933700166f7706e820aae3628d47f25cace06eb2582a56337d2f3b806"
    sha256 cellar: :any_skip_relocation, big_sur:       "71ced52f3febf5f6fec19a8be912cb02b75c774ed46a2e6f9200ea4fc6388dea"
    sha256 cellar: :any_skip_relocation, catalina:      "e8e7a7651a1c976892d72b78ff960df60e5f8f324875dfa1a7fa5a6b8f00b994"
    sha256 cellar: :any_skip_relocation, mojave:        "7e9abb7f26f6522d0f9faef15c812e045faeccc621256949932be489f2c5e5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e069c306469effda904ce11342ef59ebc3e4a6b705ca1da300e52a87900a8bac"
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
