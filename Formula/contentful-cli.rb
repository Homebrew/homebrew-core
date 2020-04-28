require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.25.tgz"
  sha256 "ca6fcdd21447228c9e230c472bd20ce14c28efa6565247f32ec3359a6c883426"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8908aec71bc5bef4b8eeaf4ee8fab59b21818b72d152502e040e12395785d2c0" => :catalina
    sha256 "2652fd0bdc6f14e2984a889cb4cd22eee565e0996c4ff0705b34f3a15842bb2f" => :mojave
    sha256 "99cbb7b13c157fa1a37a256aeabfa85a8f3876338c752e1ecd0517c2a5f85223" => :high_sierra
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
