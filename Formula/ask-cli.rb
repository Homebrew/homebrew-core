require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.7.9.tgz"
  sha256 "414f5b1af0c05359969331b8daa73abbaf9b286ecd8bd57b2094fc37dce4b81f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8844de09319fe2ccf714ecf3202e2e00c1d4dae136130855470582269b745fbb" => :mojave
    sha256 "c40f29966bbb0486e3cf0dec38a9139a86baaf7ab7878187f9d427b0366c34b4" => :high_sierra
    sha256 "6b973f039ffc45378349ca3c94d98398198eacb8fc7623d9ef5fcfe066bc09a0" => :sierra
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
