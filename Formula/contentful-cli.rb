require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.15.tgz"
  sha256 "e0e08aae0db2487bd74cf51cbc177ddc7f78b63fb6d269a52ba23d4ed78a1e12"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52633fa3af8197636ea614cff3dfa9d52caa8a32a34e71e69534be5e345ea5f6" => :catalina
    sha256 "0a6c9080e6e22ea2b7689f14d8c5359b6b4ba1261f76a805332e6e572b979a3d" => :mojave
    sha256 "6fc6e36eea36033c11c1adbdcfc50ef1279ed24172b5d7c9ee375413be11c823" => :high_sierra
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
