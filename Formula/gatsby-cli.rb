require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.30.tgz"
  sha256 "0fcc5ff04d28d01c3b9c508a48532406757961948148bb720f82d2129855ebb6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9b689c5f2d432e8116274592aed70f46a984fb0a4c4df360f5eeda4ae9541dd" => :mojave
    sha256 "b28662b2463ffd2388b72ef9dcef714ff89a48c8a9b5b755dc4828dc8d497477" => :high_sierra
    sha256 "1cf06602e5f03d1ba97f5a08ff75f21189e71a1c94ed2add8280971c5343a556" => :sierra
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
