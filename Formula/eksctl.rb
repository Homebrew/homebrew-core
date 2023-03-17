class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.134.0",
      revision: "97d10e0c6541b71a743cfbe2c2eec5543ecbb611"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a990985193026f3ff96df490275d152c6665e9d3320da448c2f785e39e0a3e24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bc535b94fd7bd15add32fac9678e115e3fe5a801e55171ec489bb42d4b5733f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c215596cc924d290a4e172abffcd0a1234f0e664f50eb16b8b2424bd692c70e6"
    sha256 cellar: :any_skip_relocation, ventura:        "762e1e5067ba3dfb425b4a98f4a9f14d8391e79daa7d0abf78007b72c1e4d1c2"
    sha256 cellar: :any_skip_relocation, monterey:       "dadd666e6fb2aca10c6749ba35957e688d781cb466eaa3c6699677f340e8ef1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "24168b4662aad3357f76b1a0c10afbfb196abffefbe8d94ed4604061ae54f9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6053a11bc1ed804d5647696bef6c80a12a4bb0d92d4ef3fa25a0744b0dca47e8"
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
