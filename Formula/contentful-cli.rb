require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.12.5.tgz"
  sha256 "7f4a3cba402dc72a03317ef3e9787f04d24800b3724f08184fc6ab922a491dd2"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ec5d768e39731af7e4e2d50bf7d0534c018e04637f620f7c035211c8b327009"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ec5d768e39731af7e4e2d50bf7d0534c018e04637f620f7c035211c8b327009"
    sha256 cellar: :any_skip_relocation, monterey:       "5b5d5a02b8e0735cdf169430d8e0fb5355cd1e77f47a4f46a6cd95fe6be6977c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b5d5a02b8e0735cdf169430d8e0fb5355cd1e77f47a4f46a6cd95fe6be6977c"
    sha256 cellar: :any_skip_relocation, catalina:       "5b5d5a02b8e0735cdf169430d8e0fb5355cd1e77f47a4f46a6cd95fe6be6977c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ec5d768e39731af7e4e2d50bf7d0534c018e04637f620f7c035211c8b327009"
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
