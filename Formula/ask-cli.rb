require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.18.tgz"
  sha256 "db7eaec076de5ece800e1b2b665e81badc1a1237fe68e8b3ed5a245bfc10d3f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd8930f78a38e8db0c6cd4a5feb7e20cade8401c743c92a45b6dcdd0ebfb3c5a" => :catalina
    sha256 "fa55fd1cd3f61b9f335db3a8da71f6e4b4bdb06f8f3c31668840aba7c4cbf2af" => :mojave
    sha256 "097b6aa7a5a82a778f7707790be40d98701c88392407be6ec6bd922c4685e796" => :high_sierra
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
