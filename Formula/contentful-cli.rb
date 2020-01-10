require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.5.tgz"
  sha256 "8ab66f57a01ca086261c77f9b94e245c0798042c38d8dd343789bdc1e75e5e91"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91ccaad35dd72c54ce817b821c53a0ec76cbe7ac4835aaf6b87267d198c1bbc2" => :catalina
    sha256 "75d86fe236ceae0a4fcdafae14e226cb238b600145a9299f12abe8fc5918c943" => :mojave
    sha256 "d8bf8d0c32b6e4a24806933b793e85acee041d90a4279153fda6d8b1275452d3" => :high_sierra
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
