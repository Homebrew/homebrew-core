require "language/node"

class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-3.3.0.tgz"
  sha256 "1f6097c0f1d8215812af08bd446a9de3e5883d550d296491dafabe837c2f1b19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5098677243910155573da561568a4203fe876d24e71b87438d320c6f508dd3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5098677243910155573da561568a4203fe876d24e71b87438d320c6f508dd3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5098677243910155573da561568a4203fe876d24e71b87438d320c6f508dd3d"
    sha256 cellar: :any_skip_relocation, ventura:        "2356efd62ded4c162ca3be67c0ea19578d5810944a6b74ffd35fed3d4d3f0e38"
    sha256 cellar: :any_skip_relocation, monterey:       "2356efd62ded4c162ca3be67c0ea19578d5810944a6b74ffd35fed3d4d3f0e38"
    sha256 cellar: :any_skip_relocation, big_sur:        "2356efd62ded4c162ca3be67c0ea19578d5810944a6b74ffd35fed3d4d3f0e38"
    sha256 cellar: :any_skip_relocation, catalina:       "2356efd62ded4c162ca3be67c0ea19578d5810944a6b74ffd35fed3d4d3f0e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5098677243910155573da561568a4203fe876d24e71b87438d320c6f508dd3d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/bash-language-server start", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
