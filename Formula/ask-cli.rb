require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.25.0.tgz"
  sha256 "ad4c1056e0f9828c08a0ff39700a38246d7fac6ef703b545d56fbd6784bc3861"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ac3f4a96bd2c79484892e4a7740c72edb6c2141365551ab1402762ca57aa099"
    sha256 cellar: :any_skip_relocation, big_sur:       "18c34ee050739e525549fa2fe79fc5cd0ed36db58031150802744fc2b010294f"
    sha256 cellar: :any_skip_relocation, catalina:      "26372a8bfdd117c11e7dce55d2946db943ddd3b035e30671c654a9213dff3551"
    sha256 cellar: :any_skip_relocation, mojave:        "a8b73172e29b4295b9c780261876f6a57cfb8545474cd0d4205f31d6048bf2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2512f4176778dd8ab682ce80b4112fa0e3762a2b7a4679f2da8923290a405e9a"
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
