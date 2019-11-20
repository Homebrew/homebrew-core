require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.13.tgz"
  sha256 "cc6238c39a33c67281b96f2bbd0ae2dfd81b7b18ccd1db77f6559a8178f3bfcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "9aca92a5495ba5a6487cff3d58638ebd24d58fa39bb51a0c269fbeaa514b1c10" => :catalina
    sha256 "549708d7c6b38c600d7b272a0c90966f04b3e633180c7e188df9a468ee1b16ab" => :mojave
    sha256 "82f493d40e86cc412871c7b9b9fb8faf521d1ef958cecc941f5ffcdbaa06f848" => :high_sierra
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
