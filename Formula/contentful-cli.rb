require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.12.0.tgz"
  sha256 "f4942fed961ce802c904e832f867caa400ec5f22ef3d4b9a55f7f95d8442c840"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06ebb3a2e7322a324122e6379391f14e202675c3969454cf63bb4c0732a05b24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06ebb3a2e7322a324122e6379391f14e202675c3969454cf63bb4c0732a05b24"
    sha256 cellar: :any_skip_relocation, monterey:       "89280361a984dbb852900ff7c0144d85ae417022834fb5fb62334eb52736c685"
    sha256 cellar: :any_skip_relocation, big_sur:        "89280361a984dbb852900ff7c0144d85ae417022834fb5fb62334eb52736c685"
    sha256 cellar: :any_skip_relocation, catalina:       "89280361a984dbb852900ff7c0144d85ae417022834fb5fb62334eb52736c685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ebb3a2e7322a324122e6379391f14e202675c3969454cf63bb4c0732a05b24"
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
