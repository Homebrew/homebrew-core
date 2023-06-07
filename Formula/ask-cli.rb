require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.0.tgz"
  sha256 "6839f8ae29bfe92f027acb63348d23cb53dc23484a3722dd5f038dc2e9dbbb21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a006fc6e727d71b1055a1fcc755bdb72fd3870fbe9c91062cf3df50b6158aa21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b82c5a832dcdbefc2ecd5e9ac0ce2a5f7099dff6a0eb75d094001b1fbc37ca17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ccbe0c87cb74c3404a1e28d724380f38e3a07ee828fc277d9bdb752d4e02be2"
    sha256 cellar: :any_skip_relocation, ventura:        "1ddb3373199897f9a9744d3d53b042b2c09be7d0b462d45ad4b9bb5086fcb87d"
    sha256 cellar: :any_skip_relocation, monterey:       "59f43e48e9bdf57daf8721f039a46d32afa20a86c5f8c8fd01930eadadfa384f"
    sha256 cellar: :any_skip_relocation, big_sur:        "24831d651e88618325ac455a046bf56b3f137b44acb65fdcf3c3d0b75c570c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d022d3e0efdd97cce05e5513ae03754ab1b8da57b524fca129cd43d641acf88"
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
