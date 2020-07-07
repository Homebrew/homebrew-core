require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.11.2.tgz"
  sha256 "57b9a94a63c1b2d2be63e2a374ee84f3e4bc5547e4430e14c47e72ec81f0ff76"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dced66ff98b6b76395ad2fe9efe4efc6a168576168eb94619edbcb639f6bcf1" => :catalina
    sha256 "abd4865724c072dd0495b882ced8d9a22952bfcf3703156099d619cb7298d24d" => :mojave
    sha256 "cc2a74bb91d72e0ef5aa5844ed087c2e7c19e1e2bac38629b632dfa45b32d601" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
