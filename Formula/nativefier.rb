require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.4.0.tgz"
  sha256 "a998f6370c116ba786ad4b168f9b84be94e9ff96fbc0f07801435babfc60fea4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ad7c82d1de3dd0d4ce4a7a70645765ee8024062794ac0cde539b108cbfc043d" => :sierra
    sha256 "1d29984851975ba710ad4079f1202008b7c82b085c798a55fa1ed4ed6705e458" => :el_capitan
    sha256 "10a276a49b6ea7414c0c5a309ca4918a86819f4d5947f9914b59ac0cf2e82c80" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
