require "language/node"

class Mailsy < Formula
  desc "Quickly generate a temporary email address"
  homepage "https://github.com/BalliAsghar/Mailsy"
  url "https://registry.npmjs.org/mailsy/-/mailsy-3.0.8.tgz"
  sha256 "7de521c277029e4ad0b373b2a89310caff08afcb2cd861e50f2c8dfaa292e13c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5a68f81b021e6e03a4df36823d2d7d100a43488e445711b046e0e80671cd324"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5a68f81b021e6e03a4df36823d2d7d100a43488e445711b046e0e80671cd324"
    sha256 cellar: :any_skip_relocation, monterey:       "b0cb9ef81f1f4287850c4b05768f952af3ca8fcf5bc1ad04c4a9758664389aec"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0cb9ef81f1f4287850c4b05768f952af3ca8fcf5bc1ad04c4a9758664389aec"
    sha256 cellar: :any_skip_relocation, catalina:       "b0cb9ef81f1f4287850c4b05768f952af3ca8fcf5bc1ad04c4a9758664389aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a68f81b021e6e03a4df36823d2d7d100a43488e445711b046e0e80671cd324"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Account not created yet", shell_output("#{bin}/mailsy me")
    assert_match "Account not created yet", shell_output("#{bin}/mailsy d")
  end
end
