require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.49.tgz"
  sha256 "4872354fbb79377737e2a138820024c9de1d676a06ab08d173cb063c051ea770"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "147ba703297cc7d26c3a2937d22b78931c93cb3b3acb2f0326f2cb1b52f8c2e2" => :catalina
    sha256 "aa273314523da754bebb230421d6a9590fcd7f02b6f36bd9d92eb5c85a39f910" => :mojave
    sha256 "746d262c686ee99157838fb9f8a580a7ee4e7a0733c0b8bc2cf5d66df0bd9b68" => :high_sierra
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
