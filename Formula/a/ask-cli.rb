require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://github.com/alexa/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.30.5.tgz"
  sha256 "1755238d460cd1feff894c9e614290afb440348a52026ff467e76070c75fcbe3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcacddbdb252e40d1bfda613d9fe9ad17d71868c4cd86547a5b59544e880005e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36dcaa5801a14e95536de8a4d807cf70329d3226d04510bdd756d38caf03780c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2427f48869cae9c7e10d6595e952934470de2434280d6e05d8dbceacc59904e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a588c306aa778011f45a1df6e2b74fb73167eec7c38ceda8cbd687e524af8fa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8146cd46856b603ccc344d96da672b454c34c9dcad8564efb2952f76788c9a91"
    sha256 cellar: :any_skip_relocation, ventura:        "97f9c9927677a2dba14e8c4a1c7c5d60665c9d3d979fc10ac5960b4ac059923a"
    sha256 cellar: :any_skip_relocation, monterey:       "ce63043432feca79d4e4019ff11321192a10b9534ae4595d24e2558d31c124d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "219a0f7d028a2f26322bfce2da5e1ba9ee2eae3c3900ef6082e9c3e4db1423c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab321ed006483449a6967221b6a4a87d78f56f4645aae2c2063024a2c199c9eb"
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
