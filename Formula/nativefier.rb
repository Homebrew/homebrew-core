require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-9.1.0.tgz"
  sha256 "1614ff9c955c6687f813884b795051e9ffccdbfb8248a0ebf1b6b74cd2b39b35"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "330bdc626c754bec5d99aee484139c2c5feaa6f5793ef12ad2246e36376bf03d" => :catalina
    sha256 "c241951545708abf02ebe88bf208e18aaba9d11e23a4e1b411200d7c17540c92" => :mojave
    sha256 "7d74b9bd002ae241140ea4ca2b33dd466dd795f0fb29e28d9e7f80a53f0c9f47" => :high_sierra
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
