require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.16.tgz"
  sha256 "0cf449da78cc44e3629d93cc8dbe7e9ffe756fafffae07a7c100c2c4dd9ba196"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42762eacd54e1bb4832a378ab1217678c4d46568131e7fb0401acf69ed2bb4ce" => :catalina
    sha256 "844eac018440acf3aa30a89b1102b2f99c9b30b2ff2974c3ec3e89da220dcae1" => :mojave
    sha256 "afd9426c20854f3e8c0099e134ed131a0d1185bcf0eb6d1e30d43a793b1ad0fb" => :high_sierra
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
