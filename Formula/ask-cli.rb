require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.11.1.tgz"
  sha256 "4df127b2cae43d45fe6d2b4fb56d53fa10b48e1c79c72a166017074c688a2da8"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f9755ac2b16f6b6c32dd8a20f00ee894e8e5aed2e6c71325e9e9c14d88bf59f" => :catalina
    sha256 "145e41bf90e5056a94daa4e16085b27bc873a79c21acdb0173fb853717f0eb33" => :mojave
    sha256 "1a848c609be08b0cc2e326878794ff5223d7e847e54770f17e98993e4ee594bf" => :high_sierra
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
