require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.20.tgz"
  sha256 "689d6646f28ec5c10e5d8b1bb2157eafdf4f59b473e3726d3640cb06ebe1f7e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "d96d1bb8496f0e52aba1978483afd60b0c8836e6c51f9579481d932b73cdbd24" => :catalina
    sha256 "8ef070dc7beb4b05211f2a4a6a7977070266835c81f04f0c46cada91d1d53a61" => :mojave
    sha256 "6a77fd79d72134f3e31eb45120748ca2b6af2fff6ff6f6e9bd7598646198ca5b" => :high_sierra
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
