require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.0.tgz"
  sha256 "beba4cbc7fa42242a032dbdb99ec99f58dc78b079d3d2a7a23392c3acc44f061"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52d89e7abb7f76140a265b1a2f2d9823a2ac376912813d2d90570b205a19be97" => :catalina
    sha256 "56bfbaa13d1dcee4a4a84f3fbbda4781b2e15f199ef947b71e795f7be753d810" => :mojave
    sha256 "1ae0842c2b9ae0ea8621629183d26e2d5a57fe250db8d224c64175869bafc5c9" => :high_sierra
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
