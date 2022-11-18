class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.120.0",
      revision: "906c681592a27d3d2903bb7131392faa88318c9c"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da64127626ee2f8d1fe87aa47dd58acec7a954b7ac9a98f401b6ed02458a6c66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "058cacb2ca0930fdc98c3a4973c2645f9b906fb9fa23670dba9a4c8b452f482d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586d20e173ed4a74fdc48333f4e37d172bad9841b857b474780640f4d512b1e8"
    sha256 cellar: :any_skip_relocation, monterey:       "89126b8abe31778ae351694d11a5934788cba5d910a5835fda94e0fdacaf1572"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a7fe3d950614c227d62a71f8b2df542b3aa4a70812069cfa29db462824e41ba"
    sha256 cellar: :any_skip_relocation, catalina:       "b5b49ba05bb0c09147a0df41493646edd50ba84f80982efb8e25739ccdfeeb68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97961bd7999ead78d24c7cde0bf2cc669d3155257d86a2be26ce7dd9513747c6"
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
