require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.14.tgz"
  sha256 "7947ed80b8c312fb0117d847a83ad156602e9ae8f3bf68c146a7281c174ba62d"

  bottle do
    sha256 "3d576026c43fe4e7d24c6620db57b1e119150f66ecea2501d98c5284aaf46cb1" => :catalina
    sha256 "d565017e229361968258b015f63322fb09f97d23b207ff18a1e94508c25dd2ff" => :mojave
    sha256 "fb46340927d4062d6a65a104b81adbda77eb08f3d20b30d44f08014d81b9d6db" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match %r{\AInvalid json: [^ ]+\/.ask\/cli_config\Z}, output
    system "#{bin}/ask", "lambda", "--help"
  end
end
