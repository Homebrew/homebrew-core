require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.17.tgz"
  sha256 "bedd9f35fd8b861df6068150386d3254f34fd5b4646677216a15a5006335147a"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b38e4a25db573d718b081b74a69acf07319d663b05e07522f788174af07c9f1" => :catalina
    sha256 "f1af22e1d3fca4f9c7b4996fb615eac7afae3b7463e11d8bc8915cfaa0aab796" => :mojave
    sha256 "b2b6a6fdabe817093fc82425f331ca56f5cb3d31efc10ccd8200ae655b0ef9fc" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
