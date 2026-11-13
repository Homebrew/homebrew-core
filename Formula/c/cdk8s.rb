class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.81.tgz"
  sha256 "bf54ca010e30147eb1df0fa785ee333ba1268b13769b1059a00bb08a125698a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d75be2cbdc5548526a2e3216c82ea3462987cb667c068ab303bf35add5fc4736"
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
