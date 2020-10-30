require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.46.tgz"
  sha256 "98fd9bd65818d87b2110e302ff16d47246b4f0fa61ac25c90e9dd57e3c4eeaa1"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "72326730602938a6a60723ca92f1283918acc0102bc686343383ceb61695983a" => :catalina
    sha256 "b27425d1cfa10cb4d707b506cabb087a4f32a13b7fea8a4cdd1451b35d11392a" => :mojave
    sha256 "5aa82e5e113766e55478d8e558fbe0fa761ac87534099c8f20b7a03aa878bfd0" => :high_sierra
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
    assert_match "Or provide a management token via --management-token argument", output
  end
end
