require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.16.0.tgz"
  sha256 "14d4a283295abd9dc7b3bb3e5dac3af0f0257dadaad3144cec46452459cbc894"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bbc70841a015ba9f39ca88c41aaa936a32a11d2587c5a5c6d798875250b0d6f1" => :big_sur
    sha256 "c07aca7a18878d2ca21f3abc063e124e85f3ada463def9dbe498ac82c1a04e84" => :catalina
    sha256 "4be75fb2d86c23ea8656a147e3d5c7b9ae6379d8f462da2d16fe3e84215e1ce7" => :mojave
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
