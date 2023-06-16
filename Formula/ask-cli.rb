require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.1.tgz"
  sha256 "2a5cadb60b1976413c16dfaca31ef4af0e5cedfc8fe5c22135583373abb68cc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6828388e95fc14b5803db6eb8f62ae188b9db83c05554ac0b4343173d1329b38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "797da1d6485f31d6a5af13558c5bad65123e68ff8e3f155bba83764bf416f0fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fdd6eb223f1234def34d27754284040dd60b60e33f72480929ab3e648643cef"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a443918bbdea40058b6a81346bcc863de342a6dfb33884fd4e91e512a3f45a"
    sha256 cellar: :any_skip_relocation, monterey:       "5afa3d459c8fad67c8e9cdd98e135c90d702c5a79235db55b4333d4dfc2ee54d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4e2389d555db3b33e7d767bb63f38d535007d2c7978ce3cb34129aecc0f6b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b5e036c55b3c5e67d827fb1605c214c1ab4fc5f49f688d77e0b365752afb74d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
