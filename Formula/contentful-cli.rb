require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.8.tgz"
  sha256 "f6a9e4fd05eb19e88a741fff6ba8baa19ef0160ff3541a946fe6116df56bf24e"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "799653fbf0d3cf2fd213b8b15034f3dab0cd3f037d8405171eae4c0559b45978" => :catalina
    sha256 "8d7db472a0115a44408c0a18471c4004386a1ecd141c78d5d2391860ad3f8b3a" => :mojave
    sha256 "671e505f644e299b2d0b31961553f13b44f0e54dc3cf2ec3d3dbfccfa087e63a" => :high_sierra
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
