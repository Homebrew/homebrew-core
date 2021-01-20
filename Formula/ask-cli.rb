require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.22.3.tgz"
  sha256 "40dcf8af22a58f97af9e1c11a13df14726bef45a58fa9a7aff843239be5e5262"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b316ba8239346d1f652b2625b0882a6afbd4acd16c7acd3d3605a6c10c0bde27" => :big_sur
    sha256 "7fe13ff824fcb0982539153a8f5ce6b7804166824c9466d647139aa81085031a" => :arm64_big_sur
    sha256 "34c30d742b54d2ee9497ab9920c87bf51455bcdc133bee59a6df4c607a26848d" => :catalina
    sha256 "8ad62477fcdf0adfee2c379978f4a5a92a69a06ce42521d08e2a612edd8be92b" => :mojave
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
