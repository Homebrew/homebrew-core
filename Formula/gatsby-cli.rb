require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.16.tgz"
  sha256 "2102811d89d3cabe35c347af43c4809ce1fba29ca33e9825748b7768654a49a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aa9718cdf0362f9cb2bbf45967292bbcc9bdcc4e872b03d6a83a439d223cdd1" => :mojave
    sha256 "08fbba07925cb247c3f2fbc4f97f2ed9e78056015422e41adc7b794a3a90cd4a" => :high_sierra
    sha256 "ea3115e419467730a68a421975f9f9176ea06715d82345e9ffe83a6c3a045bc5" => :sierra
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
