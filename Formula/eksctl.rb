class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.111.0",
      revision: "9a99e9218dca43507e940996072ab3872da9361a"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec34e8bcf6a3755722971bedd6e12409596a22ff5841dd4906c14b16ba08c70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cab34458abbf5d00b65dae92378bd8e2ea5d9e02e1b06a072c95fd122f3344f"
    sha256 cellar: :any_skip_relocation, monterey:       "eec7cf9b7a152517f5e3fb495bb8b32b716a579bc2aa6b3b483132c8110a2c65"
    sha256 cellar: :any_skip_relocation, big_sur:        "c85f567154a0b7aa2327db02f2f3762f591bac80a66308cfce7a6e38d77e0bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "03c1fb33cf89187b2339c2914f85b083f08d8afec9578926e18efb2c2241d42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6602e5db6996207497ac4f36c46c4b0096f0eb739f68f2dee68690bd39c43c75"
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
