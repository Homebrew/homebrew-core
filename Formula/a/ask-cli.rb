require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.6.tgz"
  sha256 "0847c471956e67a0defdd59f06e69fd985738ffb6581a61b74d0ad5bc0d38a33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8419c3f3e3c1d36b4079ba279ec9258358ab2dec6c88eef18a5cb4d3599bf30d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a62f1495c7777e937b64b4e425c1fbaac7488a10126f3892f267b3431af2bc2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90398e9e1d32519c9ae06229060ad3740ffe6339949446b68378f64d1085d432"
    sha256 cellar: :any_skip_relocation, sonoma:         "57ba0e87f3bf964ebc2119e3adf14620afae4a4452fb6b8fa0be3afa603a5f8f"
    sha256 cellar: :any_skip_relocation, ventura:        "db83c4e885674dcc7d3116031127483dc9cf9659d12e0a18646591707847989d"
    sha256 cellar: :any_skip_relocation, monterey:       "1001212815d7e9f92f669fb4948e569d41c4c82554d11c429d20bde75263bb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce19299d9636ad23c629953ed222300d5a421817151852464fc7b34e70f7af21"
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
    assert_match "File #{testpath}/.ask/cli_config not exists.", output
  end
end
