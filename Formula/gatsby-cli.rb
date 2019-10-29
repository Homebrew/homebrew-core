require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.8.tgz"
  sha256 "c8f4cfab4d958f9d2e318ee6d5e4b2441adaeab77cd332b1861d1cc2becfd310"

  bottle do
    cellar :any_skip_relocation
    sha256 "313ebaa20a1a58e89952148467287802de8569e95611512138ad84a835cdd2d4" => :catalina
    sha256 "af56222b26bbe40ca1e48a7ebd5fb9fc6884acdd61f0643086f624a3248b3db5" => :mojave
    sha256 "fd2a3e58b28cdf49b62866472b296db72f2c98d879aebf2264576bfec8b82c13" => :high_sierra
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
