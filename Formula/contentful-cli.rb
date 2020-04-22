require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.19.tgz"
  sha256 "8cd9bdb222184c8d55468e505eb3107336fdc9fd07a168dd2442871fc2d2a202"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4d87be0af45f5f1444f858de8ea9eb8b18c3ef693a1f3502ef26e3e62af203a" => :catalina
    sha256 "691b7cfa1b00efb383d34b8ab5a91d176a20a5a5ec5bcb9cc861edc856e9025e" => :mojave
    sha256 "b555168c162e97da226ca86b0b02d4f5d6b7262aa01cddce2edb606db15de61d" => :high_sierra
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
