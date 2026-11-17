class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.85.tgz"
  sha256 "421cafdf9e512849478f725a5081cf7ac33f531cc72195a62f498c90ffff5320"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d396b00ec12467638ae402d1e5bb04dd5d48ffcffc894e904aa582a91ed857a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
