require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.34.tgz"
  sha256 "c86011824321ece5af89d4ce564b0dbd14f7a767620c7e2dc9fd8f4af1d960a0"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0dc5864680799272d9d51e2c5c8c7258bad536ef2f58d06ea1588fdc16925cd" => :catalina
    sha256 "c4c8ed63c3523eb5de9b8ba29f3b86e3c5227116ef51d2404ab3f87414edfcaa" => :mojave
    sha256 "6921c85aadbdea08f07597c15ed895a7d6735339227a6b05d8f44a58f8f6a1cf" => :high_sierra
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
