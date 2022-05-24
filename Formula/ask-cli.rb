require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.27.0.tgz"
  sha256 "9b96ed121ddcc0f7c281be6125d4d7eb03478fa0586d8e9f0c5f10c5db279aeb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c453a4507ef4b1a8abf80a0789e409438828ac392691450c022632b60ab8f03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4969c588256b4e5bc563a95eb13bb70fbe04769fa3ea61d1ea4d6ad892aca53"
    sha256 cellar: :any_skip_relocation, monterey:       "09c6d86999ba960f954684b367b9681e8af1844a234dc3c3d3a28d2f195c7690"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5fa02c34a8c9b1be5f597794518ee9e639e24372169a9c82bae3a72865f988f"
    sha256 cellar: :any_skip_relocation, catalina:       "826eaaa3e956fc0ceaf74965d006b1694445a6332982a2e8d142cd069e7da7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a010949de4c007fdc30c3ce0aa64f70239a485eeb7dc5475f04f7d4278deebc"
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
