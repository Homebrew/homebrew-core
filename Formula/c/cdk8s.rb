class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.206.7.tgz"
  sha256 "6e4d77d4702d6a68ef1c382997f5c7238717e22c100820bc36e48e98982571b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5831c36de7eb6d73ddd03a2a736ebb7b808c2d1a31af0ead34c66421ccdc225f"
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
