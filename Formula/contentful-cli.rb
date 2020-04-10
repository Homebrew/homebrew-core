require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.14.tgz"
  sha256 "0bc3fc71440fa52cf92ae4841a07d2248e0be4c52d420623bc1dac6ff3cd7097"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecc188ab0f399f476ae7abe28b399fd51db923fbc6b4183c12dd525464de0dc1" => :catalina
    sha256 "5df820dd510402e3d0367d9aeb83b2a5f0a529bff5a22d1e613e665a6aa4bc09" => :mojave
    sha256 "7fd669a8f7fc3b1142bfff186b24757bef2690d71b9f29e3ea76ae48d545114d" => :high_sierra
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
