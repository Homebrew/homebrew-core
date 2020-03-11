require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.7.tgz"
  sha256 "3b691d5ce29b60ea1ba1568bebfa017f9c49a897fc32d7e5f5a95b457e1445e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5481230b55ed153529dbebfea94d197e3f27e61224591ac47b1803c8fc86f184" => :catalina
    sha256 "8884453a9129266c582528944d66ad513c1a7a54a0ad532ced13452de416e1c1" => :mojave
    sha256 "b40524da14ba34a4aa028e9672acb2cd5d31f2ba4069f9ce4ea42a2a424792a3" => :high_sierra
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
