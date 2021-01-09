require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.17.0.tgz"
  sha256 "2fe38fb98ac6ffda075f63cd4b123fcdbca370609bb55ccab78de895fb0c2af0"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9846645280cea38ded104d8746a4101fa46ed7dbc7ac2c8f429f676fb489fecb" => :big_sur
    sha256 "f05a43eed2f1f20c5647696db4bc8c4755f01024c1ba3d5bf6057526815da63c" => :arm64_big_sur
    sha256 "6b3787c27b7e558c1cbf135696252b32b2d625893d8979d26d48989a6f36b679" => :catalina
    sha256 "6900f7d070b93815042f7f3e3c1fa7e4e39369b4a193bfea1e1103777f4de68a" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
