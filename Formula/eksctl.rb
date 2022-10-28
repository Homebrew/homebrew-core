class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.116.0",
      revision: "9db3d29ea486990ba190e008f771b1e7b9df6b14"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d366c33f3da1c7cdfe98d51e0663d6a16f1eccf6d7ae08b8ddb6a228e68835c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1260a946026ac9b7eadb5495c551dded1b804a3bfe440d4e5b0aa432e612ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7264e8c84a68c59516f694511bdbd27c5c3eccd70a21d00403ed8c124332e102"
    sha256 cellar: :any_skip_relocation, monterey:       "68a93efede43c09b2a1baa7ae4f75b5dadfc706e96ec709d89cb8579e0db8546"
    sha256 cellar: :any_skip_relocation, big_sur:        "b906431c8fdd00654d9d8d3aea8ed6233622abb7802eada03525f20ca6dff3a9"
    sha256 cellar: :any_skip_relocation, catalina:       "c1aec19b49c05ce3c4104d80f06fb3545cc8ad2ce2afecc6cbd1585bccc14765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98e2ad11e48f132688bf7517515e07185d6f2dfd97a0e1867f0cd9eab82d3504"
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
