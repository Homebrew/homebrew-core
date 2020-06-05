require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.5.tgz"
  sha256 "4c2162fabf5431494bb88c03ac403cec1ce0eb6d8533ddfee56c5a2d5781c949"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f852a9df7816978818bb9adf1738635b57d53b5f4863d32d746f6edf4410c69b" => :catalina
    sha256 "ff8059e2047db6d3c85b1871f89c738e563742b2a732a5234590438654cd582c" => :mojave
    sha256 "593c9834ec4ff8fd6e798be9b3ac9b13bb096a148722d2e8c0d81d84caec1671" => :high_sierra
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
