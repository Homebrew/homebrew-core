require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.6.tgz"
  sha256 "cbe126dc5d9f0d23d5a29192af4b509277d19ccdc596bca86ad36333f49bc597"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f75cdb3997ff3930241c2957f9b9248a9bdc9a114043baa51cd65f26755cdb1" => :mojave
    sha256 "49b1fed5eac9e00a101c90ddbf93679a40d87b0228b27a8ce71976565ca041b7" => :high_sierra
    sha256 "6ebbf27120e306b1e2c7dcf731ef0639ac330778afee76291c8ff4b88c269c17" => :sierra
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
