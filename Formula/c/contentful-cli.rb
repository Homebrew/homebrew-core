require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.8.tgz"
  sha256 "19ca155985e4673830156824e0deab07236291dcddabcca6562e93e26d44ae2e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d278e1490bb52fe8cfa3557f15c2c3b267d24b5eb4c92bfeaba8205c77202bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d278e1490bb52fe8cfa3557f15c2c3b267d24b5eb4c92bfeaba8205c77202bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d278e1490bb52fe8cfa3557f15c2c3b267d24b5eb4c92bfeaba8205c77202bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "129262ee3ac8856f8809572ba32a54160197a1bc78403ef13f3df61b9cff3a90"
    sha256 cellar: :any_skip_relocation, ventura:        "129262ee3ac8856f8809572ba32a54160197a1bc78403ef13f3df61b9cff3a90"
    sha256 cellar: :any_skip_relocation, monterey:       "129262ee3ac8856f8809572ba32a54160197a1bc78403ef13f3df61b9cff3a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d278e1490bb52fe8cfa3557f15c2c3b267d24b5eb4c92bfeaba8205c77202bf"
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
