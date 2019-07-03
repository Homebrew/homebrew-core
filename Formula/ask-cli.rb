require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.5.tgz"
  sha256 "38677b258fe62080c562173390f7322cc036ee9d192bb821975bdb4563675397"

  bottle do
    cellar :any_skip_relocation
    sha256 "413e608795ad827eb5c57e5a77a4af06a36e012fbdf63439bb25effc0420720c" => :mojave
    sha256 "52846f5f38f1fdd59f1b04a3a9e48de39648b7d26d47acdc3e60b759acaea961" => :high_sierra
    sha256 "9eb1ed76f0af0550d4638103f0a1e8584bbc112e62bfae427a6ed6845cfb8183" => :sierra
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
