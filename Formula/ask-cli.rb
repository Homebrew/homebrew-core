require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.18.1.tgz"
  sha256 "7e78cc9601e1985c250716590d59972c9cb9a4af2a066cc4ba2a21a98744e744"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fe8644e5ade2de2934f5a8393f9d3d67da3a4fb6b1c0eddca0101a4f9d63223c" => :catalina
    sha256 "736cd593486a6e32ae15e5a3e8f9734a82eb1a18605ebe89ec2fdc27f52126d0" => :mojave
    sha256 "e82b05e6460f88d3718d5f0a3e00e58c3bb399cbba787fdc17e084a2cdbf1119" => :high_sierra
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
