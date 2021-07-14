require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.8.15.tgz"
  sha256 "ef5a9168be650c2e450547b3e2c7d3aaf07d9d7617b618206587db3b9a57c093"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f401fb3a27c94fa812ca58568da57be7f6e1cdeeb190658f3c53b02e97200118"
    sha256 cellar: :any_skip_relocation, big_sur:       "81199be135f9ba2d27bda1a2ad20ae2d154df533a0502c491e7fe985c3a99d7d"
    sha256 cellar: :any_skip_relocation, catalina:      "81199be135f9ba2d27bda1a2ad20ae2d154df533a0502c491e7fe985c3a99d7d"
    sha256 cellar: :any_skip_relocation, mojave:        "81199be135f9ba2d27bda1a2ad20ae2d154df533a0502c491e7fe985c3a99d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4246078de9ae62dcb39b2d55c3e308685c75c149b81cbcefea95de5ee6fcb25"
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
