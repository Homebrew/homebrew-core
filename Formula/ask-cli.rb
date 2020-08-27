require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.15.0.tgz"
  sha256 "8b4ae063b264b3c5719734c9f9c4d052710dabb7b6df010c1651f14060c08bb0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd45c6ab011fe5d001e9fa36d4cbf0dc5abcbbc9b3c36e5e402a234ebce6ad8a" => :catalina
    sha256 "c8f41317c8bac36e0bb13fbae2bba5cb4e28d31bc5e20b107a81446fad73bddb" => :mojave
    sha256 "b474a0c0759a594cd683b1b42f2943e52afd93413a1d807ca76dd21dc587214b" => :high_sierra
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
