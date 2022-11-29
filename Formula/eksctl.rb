class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.122.0",
      revision: "b7686d461b6177a9c4ef93c99e00344b78cc4c41"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a9ccfd7f4ee86def623b529a5ae8f9ccde52a02e2d0a0a8074e628c8cf625ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52f981c33721e80c228949f51c4d125e6fd0a2e7da21ea072106d7175fe4950d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f066a41b0ee4ce8591a01163fd90f832bf720a6ea7ee1aaca11954ef16b378a"
    sha256 cellar: :any_skip_relocation, ventura:        "4b32c126fe7f52382db235ac96d5a113ba958aa5df8e1fb8b10fa1a90eafcd35"
    sha256 cellar: :any_skip_relocation, monterey:       "5003ce7ed9f5039869cfcbbc92215b3988b77fc5e69079ff0fb86e100e6edfb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f1fa6a52201fe15fe89dec9b79f70ca661a0350c5102dff3da61201c0e0bacf"
    sha256 cellar: :any_skip_relocation, catalina:       "4dd39fa6c5ec235224937280e55c6f680799b1838f148a6c4672800002cd4cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0817d4c064b15748c7f11bce79417291a280648b837c6d875dd2b76b01fc1ecd"
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
