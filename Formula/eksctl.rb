class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.134.0",
      revision: "97d10e0c6541b71a743cfbe2c2eec5543ecbb611"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e00710ef485efcd573438f57eb4bc938bccd4bcdfff05bfea061ee2c5a262e80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38a328682a8aac1741906e7f209eaf6753df5cd05817a8d9b33361cda7674062"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d43db4933a4c697505104610ace03cb7f8f761180cd685526baaacebabe1c4fd"
    sha256 cellar: :any_skip_relocation, ventura:        "ebcf4e308f0a8f2086d5a9038968647a832db8e2c2e34514f476e2baa7e2ec62"
    sha256 cellar: :any_skip_relocation, monterey:       "9598a288893df7d3872ae9b1614b139fd6df3e6dca9181319891d5a893005fe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac70d622d469ae69db6953aba83baf8b7113a5a638ca0f2c66445d2c48be49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c4d201b5588b9dba4d6d444469e82394b3d4219d4fc6f2d8de4986942c65c1"
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
