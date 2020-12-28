class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.35.0",
      revision: "1eafbc7b3fa3d9c31575b51b8fbac718ec108051"
  license "Apache-2.0"
  revision 1
  head "https://github.com/weaveworks/eksctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "876e7ba4c9999eed9341b49af8096ac7ae20abb9e51ec3a053ffa5fdeb93ed11" => :big_sur
    sha256 "a27fa22b130237a3fdaaea83172b7140e5db971b5ad615fa35fbc05560d5e764" => :catalina
    sha256 "5d7e6c23147215060af88f67818ee1433fdb5fbc6807e69f08250cbd628d5967" => :mojave
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # PR ref, https://github.com/weaveworks/eksctl/pull/2987
  # remove in next release
  patch do
    url "https://github.com/chenrui333/eksctl/commit/2207612.patch?full_index=1"
    sha256 "50870dd22647f6b6252678fb5302c81aa89ca04177f3f327a044d301eb483c14"
  end

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
