class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.119.0",
      revision: "3114cbbaf5e0d504813085eeda7d19e710903350"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ce397ee143bd69b3611317cd541ea20bd5c88fc60cc299be64147a16357872a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1052302053df3b758a3f399568393a28b4605e41a5c52408f7d094944abe30ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c6b35dfb803208eef346ea462f295239db54ab8bc7b8414349d2b40d82850d1"
    sha256 cellar: :any_skip_relocation, ventura:        "58a07671ac3dd930c59db77cd9acdbf6f09b862f6094b8856e07558dfe31a019"
    sha256 cellar: :any_skip_relocation, monterey:       "dc80dc49b9557d47bff107e9a31eacfab106e7fbd29e4373ec99b40032580fa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b55e39e6f74cc3afc8f7e9e84817588ac1df56096c93a38b79718ff573d4c7b3"
    sha256 cellar: :any_skip_relocation, catalina:       "2245dbfc000151142b74d30a5e5fbf94c56483ea7ea13e5734a0f5fe38941287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "553eb528554356917a25efc89cfd894b708ded12c8028c323f87c1ef7fd96e88"
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
