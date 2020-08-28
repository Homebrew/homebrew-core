require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.15.0.tgz"
  sha256 "8b4ae063b264b3c5719734c9f9c4d052710dabb7b6df010c1651f14060c08bb0"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "df412b039b4e881837553c4c26f73720b73cad02d46ebf8090b45f0c15073147" => :catalina
    sha256 "c7bd5b9b7e734cd2a44d76aaa33c4f946eabf334824f1f249c974d19dd29f3f2" => :mojave
    sha256 "88f8ddf490537a57ae65eac917de7c281a1c6f545f45203dff165fbfaee2a93a" => :high_sierra
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
