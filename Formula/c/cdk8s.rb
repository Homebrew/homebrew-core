class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.81.tgz"
  sha256 "bf54ca010e30147eb1df0fa785ee333ba1268b13769b1059a00bb08a125698a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e0b2cc5779a09f09ab4b1d059d92be8a6484d54c0e5d53457fb43fed8bda33e"
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
