require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-5.4.0.tgz"
  sha256 "bf80f6d840f2e6cc5f6dd5e4ea0246dc45ae8f387d66f3b8d1ba3d49474f8399"
  license "MIT"
  head "https://github.com/hexojs/hexo.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45740245dd9dc4d32082c287c2e8d0690d51cc8ed78f330308196dfc9ceaf02b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c38e6ac4e73f52e5ecbcfb75cd80e8997653bc1c8d9967f5813486517ccaa01"
    sha256 cellar: :any_skip_relocation, monterey:       "8d60f23ff0b6e83cf5087da41148271cb40b5f3691992b03633eb525b0ec2ea9"
    sha256 cellar: :any_skip_relocation, big_sur:        "55bcaac970db5cb434a16c27e5165dc338cdcf6498b8243936c5bcc509ea2eae"
    sha256 cellar: :any_skip_relocation, catalina:       "5bcbf7709254e2615b78b583f8c70336ecc5f20702ae5a855d7c6bb9ac2c4908"
    sha256 cellar: :any_skip_relocation, mojave:         "dbc44b1c38643e08908e1978f0142c2caf1a6ec8a3ee6663c8038855de222612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cd4a6bb23bbec22299b6ee1e350f14a48b562a54ace403dab0ee0eae84f608e"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_predicate testpath/"blog/_config.yml", :exist?
  end
end
