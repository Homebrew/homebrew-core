require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.15.tgz"
  sha256 "bc739f0286ea453fbb25f15836f9c9b716b8a2eee747edcb5c1cac582f97279b"

  bottle do
    sha256 "8422713b2ae4cab251803d4f1f622f39317e1b4a27b88fca691e9044cba55c9e" => :catalina
    sha256 "bb44cb9a237b14bf5e8a33a5f58f7ec1835fb0d0842d4398b0d2a1aaaaece3b4" => :mojave
    sha256 "a5ee81d078130e3955456a9f07bdd19e2189e9706c91145974c8dd1ed2deba61" => :high_sierra
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
