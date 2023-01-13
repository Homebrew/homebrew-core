class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.125.0",
      revision: "5ca6aa6cc6f82a5b0fbadf713a513e392da11d99"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eda98836f0604a5b6c3f38f5801d7789b56b91daea75f8e681c616ffa68b63a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "916f715dfb461c5c59bf230de5c781c82ab53cf4f0fb74dcb53d9db121ab0b0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0afafb1bf52378e6e3ea365bb6f4a0c9276a39d5bf860f15ff8c2ba3108531e1"
    sha256 cellar: :any_skip_relocation, ventura:        "752ed876c96e0ca5356d44327c262c559950d3ea879bc6ff0bd4f378af34ff3b"
    sha256 cellar: :any_skip_relocation, monterey:       "0d02095e85a090424a70c988745af4b37d2b68b597142690f717713bafc49701"
    sha256 cellar: :any_skip_relocation, big_sur:        "76467191b1f1114c7254ed41a7ec603e54f45b0a86078c3e5c0b06c3412eb77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c5b2e011b17b2c09bfb381eb0436a362ffac8ede2f8c4f8614f57ff83f00fa"
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
