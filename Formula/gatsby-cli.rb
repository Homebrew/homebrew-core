require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.11.tgz"
  sha256 "fec9a2e84b64d5ba96702fc040d366b7b0e3475371628d2f4505256fe9799498"

  bottle do
    cellar :any_skip_relocation
    sha256 "876d5f77292ae492181a3faca55edea2cb09539a858bf246124be01f969ce49d" => :catalina
    sha256 "8c529808625f4925a7975f50f68ef166fb9435be215d61183b2920f377b9c1b9" => :mojave
    sha256 "b41ab9b242ec0d4abab615570d81db3eda0cb87c9d1e1e60754c1f4c7a35fbeb" => :high_sierra
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
