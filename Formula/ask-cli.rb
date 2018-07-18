require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.4.1.tgz"
  sha256 "6521100da683326ada697b0e6240c49fc02e272e702226bd84a43fc6c544ec03"

  bottle do
    sha256 "8ee07861d52b075e110f0690f6f63a04e36ed84c4c6973287fc120e648200f37" => :high_sierra
    sha256 "f19232ad26881f1555573276336f28eba62fad86fa6e94e93df28b587098e340" => :sierra
    sha256 "9a4d0aa00d2c5f07cc307d443fad65996292bee0bd6d63e808a8df2dca82ecd7" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match %r{\AInvalid json: [^ ]+\/.ask\/cli_config\Z}, output
  end
end
