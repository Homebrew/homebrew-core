require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.4.tgz"
  sha256 "9ca7336fa098f9545165890f7134a5af3a8f58372f916f11f7838bd12bdce791"

  bottle do
    cellar :any_skip_relocation
    sha256 "00dfa0715c461c651ba0e453207b7f1d57830daab6daff7f6e40f6a75b5eb995" => :mojave
    sha256 "6c4a4816d066ff332617e1ecde8a8678028fd33dbcbccacc23850117a5fa57d1" => :high_sierra
    sha256 "c5ed8d60d3ea245fe57d8920357203f2a0c344b8d83890b341e6e9c21bd9ea16" => :sierra
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
