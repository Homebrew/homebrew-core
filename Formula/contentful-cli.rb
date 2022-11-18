require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.15.45.tgz"
  sha256 "9beeedd8f252598d38471716548b10dea79774ae48a24ab9435070048b92fa3e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16cc87b708c9e171ab290413a0f041e208a48f40d47381e64b48c54125e89f32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16cc87b708c9e171ab290413a0f041e208a48f40d47381e64b48c54125e89f32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16cc87b708c9e171ab290413a0f041e208a48f40d47381e64b48c54125e89f32"
    sha256 cellar: :any_skip_relocation, monterey:       "61f610e414a4f38107057246e5c101240de11f6612557cb3883604fff79df285"
    sha256 cellar: :any_skip_relocation, big_sur:        "61f610e414a4f38107057246e5c101240de11f6612557cb3883604fff79df285"
    sha256 cellar: :any_skip_relocation, catalina:       "61f610e414a4f38107057246e5c101240de11f6612557cb3883604fff79df285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16cc87b708c9e171ab290413a0f041e208a48f40d47381e64b48c54125e89f32"
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
