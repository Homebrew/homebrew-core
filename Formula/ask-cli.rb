require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.13.tgz"
  sha256 "543d5deda1a2c4c66a62d55c426acf20ba8779ff675ceba74a3e36468e73183e"

  bottle do
    sha256 "2f440563a65cfbcdd60a7d28ada7a8079651fdb422d122ff47e104d5817960f4" => :mojave
    sha256 "bbad430cf73c83e782babd17a01d2d1e06c813a6d1fd8b7bc5d5cf02c6731f36" => :high_sierra
    sha256 "ac3abc0cf961d0d1d9f53afc382ca270b911f6df8a844258b57dd87d4135ee0d" => :sierra
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
