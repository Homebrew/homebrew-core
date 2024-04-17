require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.8.3.tgz"
  sha256 "6cc1b2c1bcee98f4b15f95ce4b38c8136739eef0ca6401a128f8e26b1859ce6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4fdc62387f31e8db3495c6274acdfa36cc2578bc031dc3c85c993dd4b39fb83"
    sha256 cellar: :any,                 arm64_ventura:  "a4fdc62387f31e8db3495c6274acdfa36cc2578bc031dc3c85c993dd4b39fb83"
    sha256 cellar: :any,                 arm64_monterey: "a4fdc62387f31e8db3495c6274acdfa36cc2578bc031dc3c85c993dd4b39fb83"
    sha256 cellar: :any,                 sonoma:         "82d215c246eecbb2432d0576bcfe76f201f93cc7439f8fdd86c4cc2bb5f47168"
    sha256 cellar: :any,                 ventura:        "82d215c246eecbb2432d0576bcfe76f201f93cc7439f8fdd86c4cc2bb5f47168"
    sha256 cellar: :any,                 monterey:       "82d215c246eecbb2432d0576bcfe76f201f93cc7439f8fdd86c4cc2bb5f47168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "324397148808984e6061e19a0517a2f9126ac236f0b1343814967e875cc7b8fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
