class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.sh/"
  url "https://github.com/loft-sh/devspace.git",
      tag:      "v5.18.5",
      revision: "025444ad7c568b99faaf524d90b1cd1495185459"
  license "Apache-2.0"
  head "https://github.com/loft-sh/devspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc90548b4efa2c9ce4f1cca9a17a06545be1646cc05c0c2c2a61a5ae9b4506d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feb64268e9148bd71ac8c867ae0c82443cd2c2a156f6d7cbfe33d3d93c42a33b"
    sha256 cellar: :any_skip_relocation, monterey:       "230692d7ab0d836f6359b0c7e66f5b935d4c3582909c8ab7ed95a5b23db02eb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "60bb0bc610c206f50943fb00e322de386dcacabc4439cd83e39f00d120df2306"
    sha256 cellar: :any_skip_relocation, catalina:       "516ac8bfed0d2627bdf239b1b7ae7f619f69f8b4fd1dc9f249005d07da0f6544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98e00b8e7de436cccc3417dcd9e74c7adf096352260f265a0ad06de61d16923"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
