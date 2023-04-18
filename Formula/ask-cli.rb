require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.29.1.tgz"
  sha256 "08612ffc50e2dac8a8a5492bda36c7c82fa7f1f44d700f696a50e6d3e6b9f8ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7adb3fe45ed6a52f1cdf6e61c53487f499d5409968f130110f3d1310c0bc0b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ec798427ecd4ef59f86b30cc99d181d06a0c077aa83c706f1ef4006f71fc979"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36bcb5e3d391e02f96ca6e38ea1f97751683504354414b696c275dd94bdb48f6"
    sha256 cellar: :any_skip_relocation, ventura:        "47a5eff1eb358b10dfa13d3572d1ac830357eccf5e4a42b6372eecd510961511"
    sha256 cellar: :any_skip_relocation, monterey:       "9e9c7aa62ef8e73f5673457bb87098f58d2d37bc5f87c500fbe0c82071e6f5c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1216f17149075ef07bab15e1412f71a1a91bc0c96992573390ad4a60dbcf68fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7dd8583829c1eedc039c0ec48edef8c57cdca94bf416832a5aedacf606adc46"
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
