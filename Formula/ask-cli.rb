require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.5.tgz"
  sha256 "38677b258fe62080c562173390f7322cc036ee9d192bb821975bdb4563675397"

  bottle do
    cellar :any_skip_relocation
    sha256 "1417b530b07f477d8c68dd7a215819d9f65eb7dfa35f89fa5a3160619798edac" => :mojave
    sha256 "972bf5c3e74662e53b1e14d0e7a4a060b59070f5ff09889e24d729454b6c64aa" => :high_sierra
    sha256 "05e7bc9f9f21bf96716e1911f3cd51ee5907b27473f5a81a8740bcf722e7f670" => :sierra
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
