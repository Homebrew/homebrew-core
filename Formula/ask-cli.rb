require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.13.0.tgz"
  sha256 "23fbbcab40e34ddd9741f188afa39d0c417b3466d9f9af75ec0a69eb176a94de"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c74882fe57efe90ee5b5e18a2a711a4ed81df9ee6a4678938c8a074439e85c59" => :catalina
    sha256 "38b763b249973864f58e6cde7eda0d3a46de6657ff8e6ce95308a08db8990412" => :mojave
    sha256 "91abb2c956b0603ec53e06b42f25c889fd0b83fe2cbb13233ebb2ab54aa9bba7" => :high_sierra
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
