require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.17.tgz"
  sha256 "32eebadf3115cac8b84600bacb0f5eac156c2a3e25da70cdcd96458cc419f68d"

  bottle do
    sha256 "8ca82ecb9cebf17ce23057b97a9f232a9c14bb41b4bcb14c70386f6d6e84068a" => :catalina
    sha256 "a5cb16a965dc04130a716014d9ae39ebd917d271d4f82555724d98e2fa6dd709" => :mojave
    sha256 "2afd36fe40d5efbc8ec919ffb9a635c913e7479c9aef578e0c2ff584f4e08ba3" => :high_sierra
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
