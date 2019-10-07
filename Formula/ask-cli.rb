require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.14.tgz"
  sha256 "7947ed80b8c312fb0117d847a83ad156602e9ae8f3bf68c146a7281c174ba62d"

  bottle do
    sha256 "3ebe550758bd0628d135e0dd0b42af1e69d176bec1ba579fa413851253c271de" => :mojave
    sha256 "be325154452e6aff089e37d51834fcb57adf1af02ceef3dbe2dcd7ed7643632e" => :high_sierra
    sha256 "6b1dac10f21aaa26565b7947fbdf33e28a403821cdbc664f1b17a08e97c26db9" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match %r{\AInvalid json: [^ ]+\/.ask\/cli_config\Z}, output
    system "#{bin}/ask", "lambda", "--help"
  end
end
