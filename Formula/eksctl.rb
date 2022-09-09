class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.111.0",
      revision: "9a99e9218dca43507e940996072ab3872da9361a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8985106214182f5ced21825b015c3c9cb2c402f92c36ded6a41c5df55a2144f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a14dd5b66dd4667984898f268f4a2251b0a9e82e0b5aa7a00030aad0917335f"
    sha256 cellar: :any_skip_relocation, monterey:       "f69511a73b143724fc3878c927f18fc4f137d87aaf64fe2e68abe21daea9747e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0bec557d61599f09d9e9ed34a23f2a1356affaf130e90f6ab439f35aa2b6180"
    sha256 cellar: :any_skip_relocation, catalina:       "c549f604ae7c0e727513281d5014937461a40591b83dcfd416ba7337d91cfab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04dd97dcbad9a947e29ce0d7f4df6aee15f2ad9e1476711e256302473c5827e6"
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

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
