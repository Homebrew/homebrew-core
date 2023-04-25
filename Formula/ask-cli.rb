require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.29.2.tgz"
  sha256 "4006b923bc5667936efee1cf45bd44df0a51f018be3eb8fe6ee0034cf61d6214"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e819b718a0a6a871f0358dd65f5495a564313dc185e684b9f94abead540213f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cb256219d976214e22d5636e5db75fba94dc9e1dfa4685abbf0c7fbe0d6b7b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dba3f1d99b4c5e7d74888839134f4f23d1528c3af0bb1f2f880303ab839f51af"
    sha256 cellar: :any_skip_relocation, ventura:        "23818d2a8274f1402954cf0f98a8194f01619725e984c1f269d98912a8af694f"
    sha256 cellar: :any_skip_relocation, monterey:       "c97d57d3fa12c17b08f944195bdd47c0c25a654183b8852ea5666c143fb550d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "824178a338a29f87651e684bf98ea50c4ebb0addde9a026a1fbf8d55b5b5112f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "082a494dfc04b3f8992a2fffaa375bb3b5e36496610ddc9fdeb1016c2ae4a73f"
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
