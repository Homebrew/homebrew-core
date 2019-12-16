require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.2.tgz"
  sha256 "7b6cd783d1343a13c3b156a042bd0eec5a3c7f31d4d72b01f76aa50c94c84151"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dc35031445d910f0c3560381f044ffdc0d96d3de0d583da431c85218e02367d" => :catalina
    sha256 "4ca66d9fd0762c193199f3ca3dd308c6ed9c5e03eb8cd892c9d42e8908db31f3" => :mojave
    sha256 "9783500caec381bf2b3b077d38579023e2511c2e93c418e361262b1c63cff545" => :high_sierra
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
