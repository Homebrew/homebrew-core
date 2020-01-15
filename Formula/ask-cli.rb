require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.22.tgz"
  sha256 "d7f9cbe9d02731d6810693a22eebe142ba6557fd14bba86ce5eea702d3550a68"

  bottle do
    cellar :any_skip_relocation
    sha256 "bafee83ccee4c71a54085ca699bdd21b5764e3b9fba39d9d1690874e8deeddea" => :catalina
    sha256 "4e7c3b1ef8e844d8a63968acb4bb53199dc6685e243190334b63d0e9e0f3e9f6" => :mojave
    sha256 "1bc26d3853118ea9b15785663a29862df57887d64d64d1e80c06a6b024deed3e" => :high_sierra
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
