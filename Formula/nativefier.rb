require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-47.1.3.tgz"
  sha256 "b5f75cf710cacab61c366ed367ecd243ae39e176ddf00834bded27bdd3803e7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16712510de3e9aca9846ed4abdb62f66b19b5df667acdde6639538984d82d507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16712510de3e9aca9846ed4abdb62f66b19b5df667acdde6639538984d82d507"
    sha256 cellar: :any_skip_relocation, monterey:       "e09309065ecdd197eeeb5ffa4b41f8e1e04b61f2c18d0ca94fe177b8271507d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e09309065ecdd197eeeb5ffa4b41f8e1e04b61f2c18d0ca94fe177b8271507d8"
    sha256 cellar: :any_skip_relocation, catalina:       "e09309065ecdd197eeeb5ffa4b41f8e1e04b61f2c18d0ca94fe177b8271507d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16712510de3e9aca9846ed4abdb62f66b19b5df667acdde6639538984d82d507"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
