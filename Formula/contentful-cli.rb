require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.28.tgz"
  sha256 "e26eccf1771084ffe540615baa88cf325a53730dab0dc732855ed6b11054afff"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "657ece60f047573d4ee39a9886f9b5ae37c50e2b14658fd14ce70850b30117a0" => :catalina
    sha256 "fcb169fc2ad3e1504edfaa983866dc4d1ba2d26ee986b3709188dbfd2352779b" => :mojave
    sha256 "853e7f105f9dd921d8408b99bc0b46d6dade581347d44f4512906c9cf106b7a9" => :high_sierra
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
