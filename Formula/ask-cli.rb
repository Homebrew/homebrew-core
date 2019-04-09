require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.6.2.tgz"
  sha256 "ec11c540eec91f2585d1a49b38815a18fcb25434b19d177907fac6a3eb92aef9"

  bottle do
    rebuild 1
    sha256 "3dc8c3f8e9ead7551d5dbed6237b60f7e8c50ae9578eaebec7717009ae4d141b" => :mojave
    sha256 "f66eb3ebc4807f5454a1cf1669f5679563ad1632b31bd3f3aa50730c131c0afd" => :high_sierra
    sha256 "fda0a21ea57deeae0b7aacd67c4c8a94519d08b916bbe5a3da63660db2a6874d" => :sierra
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
