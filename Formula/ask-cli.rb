require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.11.tgz"
  sha256 "a2d9ddeb5d716f99447540fb6cc6db1ad2157ef8a1dbab4ce72c61ae0600e560"

  bottle do
    sha256 "822a7e9a865b291fe9f28658e82d3c55d1de71bc0cc3558829a82569a3140a52" => :mojave
    sha256 "33ebd7ff28cb29dbc3ba539fc841bbfea1de96448639160dde304f8ceec66940" => :high_sierra
    sha256 "8ebd3432104aa0e615a312317cf7b10a6317704f224f70c40e9e5503462da512" => :sierra
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
