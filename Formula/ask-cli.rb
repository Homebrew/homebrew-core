require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.20.tgz"
  sha256 "689d6646f28ec5c10e5d8b1bb2157eafdf4f59b473e3726d3640cb06ebe1f7e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f34df41b31887a8a8550f2a465bbcd246fc586ace46f1923af0a44f5237dab7e" => :catalina
    sha256 "c8a22e1ceae155832fc933b6d057f5e6995a24a08c043086fda63e8ac4f21ed9" => :mojave
    sha256 "d164d59a697e6dadd082550301b7a51f759725de2d2322334e604be603217d66" => :high_sierra
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
