require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.8.0.tgz"
  sha256 "510fd9a3a9907169d618b24694a6895982fb275f4efa613d524c4dca4ea7f019"

  bottle do
    cellar :any_skip_relocation
    sha256 "95375b93a5bd70b2d02fb86db0b52d323fed25d3889334873a5b268a13bfa7d3" => :catalina
    sha256 "6b9d9f159086198a2af4529ce3adbccd2c481f750585c353c5e440323a83cec9" => :mojave
    sha256 "ddde68ebf9cd5352cb5024b89abafd0af831186dbe86da90693522332d0773cf" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "no such file or directory, open '#{testpath}/.ask/cli_config'", output
    system "#{bin}/ask", "lambda", "--help"
  end
end
