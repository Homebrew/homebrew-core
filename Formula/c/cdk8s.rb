require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.101.tgz"
  sha256 "07e1f8a6b1df42349c2e4a3f659c4cb47f47d366b0e4662ca985f64709e39515"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a5180ad297f9e6bb599ca1967ff88447b4cc8f1b413f2dd120397cbf4032a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a5180ad297f9e6bb599ca1967ff88447b4cc8f1b413f2dd120397cbf4032a19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a5180ad297f9e6bb599ca1967ff88447b4cc8f1b413f2dd120397cbf4032a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "b560fc15ecda1a0c7cf40e636cd95a0ee30bf23704d2f9f08ae4e8e5d34f1b06"
    sha256 cellar: :any_skip_relocation, ventura:        "b560fc15ecda1a0c7cf40e636cd95a0ee30bf23704d2f9f08ae4e8e5d34f1b06"
    sha256 cellar: :any_skip_relocation, monterey:       "b560fc15ecda1a0c7cf40e636cd95a0ee30bf23704d2f9f08ae4e8e5d34f1b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a5180ad297f9e6bb599ca1967ff88447b4cc8f1b413f2dd120397cbf4032a19"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
