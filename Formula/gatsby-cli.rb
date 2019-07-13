require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.13.tgz"
  sha256 "0da3eee67f964f7935110c234a925b2dbb3ebcdd29c7c8dcbf5c660ae80f5337"

  bottle do
    cellar :any_skip_relocation
    sha256 "8889f02dcf898c179afed7efa15065da301387cac5c699f0319ab02a45279437" => :mojave
    sha256 "5ef2a5d8b595f5572cf7b9a47e445de3977c11f518ca62f240e85769b7205c0e" => :high_sierra
    sha256 "0601090546dd2464e12238ecaf584e23f1020793a7004c292356ec671e8fef10" => :sierra
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
