require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.28.0.tgz"
  sha256 "2a48779a0caf4609155547a9ac4020f0defd98a78781177d2b1705d54a1d188c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01c411a937865505b03caa56fb77bd007aa013fc700ce18df80ce156ed6f042a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "894bab76ed98768ec3f1487a4e89c4d58daaf1587ff73a22f22904d32f59f4c9"
    sha256 cellar: :any_skip_relocation, monterey:       "741719b5541e431ca00c3d95d377ec96d5661092892578e3fe3bbf5272b5181b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bb6b2cc0fb14bfa2851459729b23fb048c9ea5a6f2ca0f56ed6866238d7957c"
    sha256 cellar: :any_skip_relocation, catalina:       "5fb344f87d678113601e87c46e82a5c89148b52a123e8f2d53f6cbe9184a6071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61424d7db537fb060c7f9021d02d5040f0b279f28872cdcb29f6cddcc9472cf8"
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
