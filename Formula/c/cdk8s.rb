class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.12.tgz"
  sha256 "8753a3d8bd4d3b920710fcd8a1d31cb0eb161eead6b06b8d98fa5e9be06ddd75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97c980a71fbc8e11c5dae337c0eedcd0db15c7ea34fbd94df298f30ff3aa0476"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
