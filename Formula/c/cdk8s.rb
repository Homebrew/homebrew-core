require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.65.tgz"
  sha256 "443887a460097dbb51948fca50c006c699c7dad2befee3ca40066c67c4706936"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9ed223aa242356bf25148899ea56f0b39d52efee7aacfbbcc7143107b57b132"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9ed223aa242356bf25148899ea56f0b39d52efee7aacfbbcc7143107b57b132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9ed223aa242356bf25148899ea56f0b39d52efee7aacfbbcc7143107b57b132"
    sha256 cellar: :any_skip_relocation, sonoma:         "646269b8262eb3b36603a49132d736be61b54f812002018faaf432ff5823ae3c"
    sha256 cellar: :any_skip_relocation, ventura:        "646269b8262eb3b36603a49132d736be61b54f812002018faaf432ff5823ae3c"
    sha256 cellar: :any_skip_relocation, monterey:       "646269b8262eb3b36603a49132d736be61b54f812002018faaf432ff5823ae3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ed223aa242356bf25148899ea56f0b39d52efee7aacfbbcc7143107b57b132"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
