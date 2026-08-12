class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.49.tgz"
  sha256 "8095ac5875ed13d1cce82cd8debbbfd0a7b5064969bcfb5d07df8e594a81d7e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60a016c6ffefffc7a1b4535d35fc66661c5f28c5ef959c55905936baf847a79f"
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
