class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.137.0",
      revision: "52f8a2c3e2964b42524b9337523f0aac822748ea"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e14367995d6f460d9de71f8e39da567d03ee813e4fe2f98c5e0e9d185c9edb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "059704586b8647634552f451baba17275be1fd44f699a409b57c9b1e20ca5006"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3f875f8d1dbcab3bbcc408d0a8b3bd1e08bec70283f468fe8e197d89a60320b"
    sha256 cellar: :any_skip_relocation, ventura:        "d91b9021e5ca667a13766b2af11ea94a1d81c77fd7385fe1e597eba1c32e7adc"
    sha256 cellar: :any_skip_relocation, monterey:       "faa51a697be1f6c5f2a8508df4b81aaddabf7ecdb92fce8ee6c8c1c90ca8e0ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "72d84d1f04412a7ca11331d59972350ffc42f1588a2975b1f0b1937f7b708436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27cae97403bf751142de829cd16f022f9fb6b001d7f781ebf327605253656a8"
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
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
