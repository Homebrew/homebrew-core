require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.57.tgz"
  sha256 "9554d4ca4cb8890b27eff95fddd12653376c8d307785b8915d624eda5a9b85d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95d15f7060b1aa71a78a036da31feb6c506b1f146d9970a4d23e334786f23f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95d15f7060b1aa71a78a036da31feb6c506b1f146d9970a4d23e334786f23f2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95d15f7060b1aa71a78a036da31feb6c506b1f146d9970a4d23e334786f23f2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7880615bf424570891a1600d64076810f124d7ba64bbb5786e7da5db95a0499c"
    sha256 cellar: :any_skip_relocation, ventura:        "7880615bf424570891a1600d64076810f124d7ba64bbb5786e7da5db95a0499c"
    sha256 cellar: :any_skip_relocation, monterey:       "7880615bf424570891a1600d64076810f124d7ba64bbb5786e7da5db95a0499c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95d15f7060b1aa71a78a036da31feb6c506b1f146d9970a4d23e334786f23f2c"
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
