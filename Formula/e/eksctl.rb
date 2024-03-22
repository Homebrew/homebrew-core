class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.175.0",
      revision: "5b28c17948a1036f26becbbc02d23e61195e8a33"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8aaac624ae7dc01ca21197ced0141ea49c608ec4c1e05eefa1e459790eadeea2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28ca33c46641fa31874804b7e9be0653b250e82a2a4324ba4cb8ffe3fd0eb27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "296c7cbbe8c97c9cac5413e226e6d35b8328ea7be3d0d65e9c21e0cb9725a896"
    sha256 cellar: :any_skip_relocation, sonoma:         "8414831d6cbe852ef1378916bccd3fc0e37d0510e081bb32be12275d450cd817"
    sha256 cellar: :any_skip_relocation, ventura:        "7054e9e881a246385611d7c6fc6b41269289f0c14647758d4aa73eeab6117490"
    sha256 cellar: :any_skip_relocation, monterey:       "58ae2459fe04d73283f599caa4a3e5f4d2c2896b15520702a4c6899da5177dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6c82f3ae9e9906d78761921b4fe9b233ec798f33bc4977270b97783f48a79c"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
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
