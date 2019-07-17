require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.8.tgz"
  sha256 "bdefa6f8f32796d73ef9d0d1a4cc5d96d41c59cdd7a53153751cc64561cc4cef"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b53eae090268622a864829d67c810057350ef6970c675e4d04b815035bc3a5a" => :mojave
    sha256 "7f4c1367e9a2613bb6425288b0dfadda4301703cf326b4efe0105abd3ac5ce29" => :high_sierra
    sha256 "62e4449019f0d98685b0dcfbcfab8b53fa34bf3f6d144a66961e3beddb903492" => :sierra
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
