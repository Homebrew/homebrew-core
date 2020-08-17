require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.24.tgz"
  sha256 "5dea6947f0aa19847e84e8cf3aa73ca637d0573b5fb39811b07b06f321987592"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "560fcdba30f4bead4c92d361b8c60ea900562888ef8ab1d9060f97ab2a18be94" => :catalina
    sha256 "34e0dc90fa4783a1ceeba9f0f782fdf5bf188821092d8df0726566e8e0604dd0" => :mojave
    sha256 "4e3fc0d23ad980e16d5e08c992b52764e673cdf88d66e2dc9c4e3cde86ad4831" => :high_sierra
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
