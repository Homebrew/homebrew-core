class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.143.0",
      revision: "8a78b705cb2c1d0df9a54f959b84322d3a36ef07"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2faca99cd783b4a6936863a381371c265708ccd5a5b2cc8cd161f2735da5b615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0af125f8366fb65d3b6620b743d8d61c8ab1ed9651ab5221fef3dbcebfe8147a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69be03e4deca6a8d6bae83ea7eda905dbdcc1db1a9347da335e222db14065ea6"
    sha256 cellar: :any_skip_relocation, ventura:        "793204756f140088d8858174dfbbec2c82b0364ab4f70cf78af9965272657b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "d6f86f40410708148bbb3cf811c2252a8cb8a98c1164616e07fc92692caa0007"
    sha256 cellar: :any_skip_relocation, big_sur:        "53c4ec3139f2e6b81509301362d280230fc6be6ebb6b10096bc7aae878777ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2890f05ef398004573571c603f4d725feea90f422b4ff3b28c53f473f7a5784e"
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
