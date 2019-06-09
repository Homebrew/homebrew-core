require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.12.tgz"
  sha256 "46f2a8cd44f1e2d64ba0f4c69ef4b7fbaba9243b48f00829747e5d93ef3033e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9478b008ffb382a3587db914ef2dfcc3efd5b74f932009b478854a5a154465c3" => :mojave
    sha256 "825598f71f9bbca76d2e8f8dd6265cbaf65df37e9734fef9f0b6267512330385" => :high_sierra
    sha256 "79ed9d5763327b00b1390456105356e9d884acb5edf41263897142a3fd0cf56a" => :sierra
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
