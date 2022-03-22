require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.12.5.tgz"
  sha256 "7f4a3cba402dc72a03317ef3e9787f04d24800b3724f08184fc6ab922a491dd2"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "397325c68cb8533a3e916b6c694c48bface6ca3ebc4f446f1f572ddae676e19d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "397325c68cb8533a3e916b6c694c48bface6ca3ebc4f446f1f572ddae676e19d"
    sha256 cellar: :any_skip_relocation, monterey:       "9922409bd7471cfe28f3531b6aa1e9a1a87bab294fd50f6686c91fd2c55c7d60"
    sha256 cellar: :any_skip_relocation, big_sur:        "9922409bd7471cfe28f3531b6aa1e9a1a87bab294fd50f6686c91fd2c55c7d60"
    sha256 cellar: :any_skip_relocation, catalina:       "9922409bd7471cfe28f3531b6aa1e9a1a87bab294fd50f6686c91fd2c55c7d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "397325c68cb8533a3e916b6c694c48bface6ca3ebc4f446f1f572ddae676e19d"
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
