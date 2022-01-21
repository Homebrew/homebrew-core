class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.80.0",
      revision: "fa2ec8f75fadee4022a05ad02f8e0609d188af80"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8856214818573c211ada5977a99c26cdbb6c45fc1f17f4d641d016bfbe993673"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb5a7d24b42957d52cef0ed3a451f82ddf15b8007836b4aa8c2f352434b6a901"
    sha256 cellar: :any_skip_relocation, monterey:       "d072575fa239ad2ba1ce547074dc115d9eac6d52c503b960dfdc30a0e8d77656"
    sha256 cellar: :any_skip_relocation, big_sur:        "d08b1f60a7177536d9cd95e7d36da85cff02c3ec37187c0a9647b05012811bee"
    sha256 cellar: :any_skip_relocation, catalina:       "c272ded155ecb9674ee640304752d97b9a7b1dbcfff6a2d44fc3c8d64a78cb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b87170d42984bbb0a104aeceb37bd26bcd7102f1eba95ebd26c0bac53bc3604"
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
