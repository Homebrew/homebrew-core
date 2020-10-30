require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.19.2.tgz"
  sha256 "89a5682ec1f46792f3c240a495959e6e9f4b4ececbd500ee717e593cc51948af"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3cbafe90d2a81eba1675eb3072ab7e728d63157266592184550673e9d25c2de1" => :catalina
    sha256 "77f6cc10b96b3328c63b92421dbb19a24ba64f8dc7b9d4c405b125a615296a2f" => :mojave
    sha256 "fe225dd130bdbe0548248642b87fb97a45c28b2c07f0c83a303b61c7523998fa" => :high_sierra
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
