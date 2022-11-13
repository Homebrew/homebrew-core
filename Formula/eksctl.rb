class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.118.0",
      revision: "19c566987fc073fc74aa7ca0e8e947f0edd9e957"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ffe392cc41a56933b2656a917b47a651541426e26001d07f5f595a90050ebdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9329900f058ee7f83f21388dcdda9f5d68125941edec27a7174262b923847118"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4b6d724ab23b5c87db57ff463198ad1cf23ce2abec53658b04fd713b047fd49"
    sha256 cellar: :any_skip_relocation, monterey:       "35e0107b03c63c3b7ee58653a260e8b3a5b5fec908872d6078cc1c82de9818c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d726a7c8056a9afee9406e1d69efaab25003603019ed045a5210bfba42d1a7f"
    sha256 cellar: :any_skip_relocation, catalina:       "4ae23dbc42b2778d90442f7166249ecd04fda7585e3d89daee3f3f2807d6cbfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c9e385cdd88653fa9dd1b0190f29380b027aa92667b63daa6b0ab699f0fc682"
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
