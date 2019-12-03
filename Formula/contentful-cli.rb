require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.1.tgz"
  sha256 "92cdbff4d67265f92490224b45450fea475a04cdda796d072e0f05079c072f2e"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a6a408c0a36d68902ad68f5fdacbed8fe9c4413391e43a67f16c23a0c6e7a34" => :catalina
    sha256 "2e5464776b1337b831482798c3d93b37e710b9535d41460d444fa2bb20c59923" => :mojave
    sha256 "0091a159058e4ee6250277948d278409eb9cddbf1eaf58da5536c46141c365d1" => :high_sierra
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
