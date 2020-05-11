require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.30.tgz"
  sha256 "a113f104958f5786d4c4a746412d3b1b211004ae5b77097ac9aa1e19e2adf28f"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0de78057a45f0146cb24a86260951825d63cb13a8db966025fb656e55083ea2" => :catalina
    sha256 "fb487f247c6f46334c982d9942dc97021455e7d5567af40faead190f216cbfcb" => :mojave
    sha256 "b4fd936ec3ba75aecdcce7cb00142d124e8a473babd4e401f1dcc2006f0cc4c6" => :high_sierra
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
