class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.116.0",
      revision: "9db3d29ea486990ba190e008f771b1e7b9df6b14"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6b175ef5aa3dc21322d22ba5fbd415c0072eb23da9d861d8ae83d644794c15c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f500e8eb1e663294e500c25509fe5eb705375c7169e2a9256a633e8c6de9bcfe"
    sha256 cellar: :any_skip_relocation, monterey:       "3d1dca6cbb5d3ae18ebb9729b4dde52ae07358de86f3d969dd8d3e6aa7e82136"
    sha256 cellar: :any_skip_relocation, big_sur:        "26d80d504dab908142476277395377ee5f5cac311880ff6c914aafd678068daa"
    sha256 cellar: :any_skip_relocation, catalina:       "c8e4216059f347e9912d0eceacfc50800dfa851571a406dd8f8ca3c6c46f526a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e42da22fbd924ba1a093ca69c642a30680eefc2f8b3212f37d687f0c86d7e0ac"
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
