require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.34.tgz"
  sha256 "d983001ca6d0472f5a8c34a92e5ed606a186d543d16a76e14720247fc22ca105"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1893ee013606fa837347e58a4c62bb268bd7e86544cd4a3c91cbe9268f808fd" => :catalina
    sha256 "abb4d8e49e5c9dddc901a59a808afe9c80bcfd962fab309289f86ef1c9a2d8f7" => :mojave
    sha256 "2d687246228a7aec1e13846e2bd446ec64784e8a76509ffadff7373b9f701eae" => :high_sierra
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
