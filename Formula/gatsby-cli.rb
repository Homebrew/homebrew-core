require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.4.tgz"
  sha256 "197cc0fb7a8eacf67a162257121af59fa8c3e5c30be0f57ba9645f74b312ced5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2aa4706e9582bcbb8b43749090f1d4d226b9294fec719328ed7d854a4b2fc4a2" => :catalina
    sha256 "03fd06732e4c30c64599f4f5b27bb2065a3305bfa75e922a8abee69b5ec232b8" => :mojave
    sha256 "9b6ba99a8de564225016dd3bf3ec2bf60ce6da62421551a6206e307b4642e206" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
