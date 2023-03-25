require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.2.15.tgz"
  sha256 "347f21c47c14bf91c6370a9dde45c1be68c2bd2a4749b2adacde52cf9f7b37d0"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faee36e94b6de7992b9da49d556eb28a95434d15e7ce7b7d41f1971a136ac5f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faee36e94b6de7992b9da49d556eb28a95434d15e7ce7b7d41f1971a136ac5f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faee36e94b6de7992b9da49d556eb28a95434d15e7ce7b7d41f1971a136ac5f8"
    sha256 cellar: :any_skip_relocation, ventura:        "09f3cd3306335acb6c18cffac24d24767edadb54923444ff093b5112356b3ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "09f3cd3306335acb6c18cffac24d24767edadb54923444ff093b5112356b3ee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "09f3cd3306335acb6c18cffac24d24767edadb54923444ff093b5112356b3ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faee36e94b6de7992b9da49d556eb28a95434d15e7ce7b7d41f1971a136ac5f8"
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
