require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.12.0.tgz"
  sha256 "417f32c3c0be94bb5cf087b862a553436b999aa8bff6f308f3f6218961842964"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "475e6b8c27a3e451554884fe73148f0107409c034202fa85fbd0c9eb355198c8" => :catalina
    sha256 "64d3f6577a7247cff4a0cbe9123f2e966f8dfddcf4e0b58b0b925642d6953ea6" => :mojave
    sha256 "d4b5c2f5efd7b4093a41d6699a3baba81484ae1b728e3bc86d79b16c7b96056c" => :high_sierra
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
