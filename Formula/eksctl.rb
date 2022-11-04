class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.117.0",
      revision: "98027776cf931a1b0c6d5513912c645c67efb236"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aff2dfc4b6ebc5bd41da525ba508b3649297f60a21a6064f563f2343a37c6be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "452ad661f5197c58593df0a106ad1a1a92eb27b7cc7a86603a6783a33baf2da4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdb92bda40e3dfbf555cbc56795a8fe3111f941665d2f7886ce47a4dce70e272"
    sha256 cellar: :any_skip_relocation, monterey:       "8682e1dcf5ed740b8996c65875bddbe84e5a02d2f95d765725ca776385ba104e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdab319336d64cafca943252e19aa4a58bcaaccebb7525d67e9ef4f2d839da1f"
    sha256 cellar: :any_skip_relocation, catalina:       "9a87699c25bf453142e6a137045443d4b7dbeb7475203c70f94bc049bb61a8e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "709fef74ef0c63f68c81440b103c6b7d775ad36680c51207c7b4aaf4ecae62b2"
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
