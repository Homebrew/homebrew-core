require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.26.0.tgz"
  sha256 "62bdf53a6113d06cf65d476ce03ac85a9d0ee5af273087e45b8c2ee1e7c70c72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c37547ad1e4c812b0f76cf50d006d68d57e63c15a2677387790180f5abfb7b3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bf6365ddc9be9b0189582e5fd8123f14dee985c30c5cf37aba629d844f5f8f3"
    sha256 cellar: :any_skip_relocation, monterey:       "8f50650df83e09b612fb58d77b1f44dabf60530a2f306cc596ed4f52b3e90067"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e23be74cde96551730c414bc5c50dcefc80c2dc5997950e4c300df55ad8b2ea"
    sha256 cellar: :any_skip_relocation, catalina:       "94c0c8ea1ca8e8d38c5301406d89d55b2d406c36ef6c8bbd7531b0c3019f3214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfdf8dd9941a646e180b8135a09cbc5eba4b2ca0159c6178d8176dc377a21aa7"
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
