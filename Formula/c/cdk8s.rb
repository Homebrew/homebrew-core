class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.80.tgz"
  sha256 "2c593e55a2b0e0ae51fb7f4b3a594096f9828c06d9223066f597bbd8f741d47e"
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
