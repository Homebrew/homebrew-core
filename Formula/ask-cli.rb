require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.9.tgz"
  sha256 "414f5b1af0c05359969331b8daa73abbaf9b286ecd8bd57b2094fc37dce4b81f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb5589dc1275f646666e484bc0c9ea4bec780ab48d974ab14a28e21556d51c66" => :mojave
    sha256 "9057e63bec8051fa93f78d9571e6dc86c1e73e2730f8ed4e4cb3831910f25f7f" => :high_sierra
    sha256 "152c09002b200991b1e119bf9e8e4cba53f8e8f7a04fe61efefa3b42ca162e88" => :sierra
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
