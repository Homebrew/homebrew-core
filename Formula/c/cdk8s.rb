class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.5.tgz"
  sha256 "0e09745f518be5835f2aa860fd9f14480d7ad96cf5cdf7bd87d6ba3c6b73ca4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "54a8812d9ad3a6a551627e57533e190dc46c53d211df0aff35cbf7e9682af3cf"
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
