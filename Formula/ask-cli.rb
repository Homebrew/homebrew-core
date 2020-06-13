require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.10.2.tgz"
  sha256 "833cbf10f51295334c37f392fa073eb9dbf21671eb8cdb372d8202874c913cb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a77c9240d603ff7ff32137a5beb26ba4f3d83f6c5e3a612446904711ad8f1a3" => :catalina
    sha256 "e8f5b02578667a5ddaead14e4ad2038c9370fe6931631268afafd964127e31cd" => :mojave
    sha256 "8ce04d9f1d86e5012ce3381b0d712034de634f3ae42415f26c364158a94c6ef2" => :high_sierra
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
