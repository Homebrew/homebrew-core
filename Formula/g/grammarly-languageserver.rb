class GrammarlyLanguageserver < Formula
  desc "Language Server for Grammarly"
  homepage "https://github.com/znck/grammarly"
  url "https://registry.npmjs.org/grammarly-languageserver/-/grammarly-languageserver-0.0.4.tgz"
  sha256 "0d50b88059b5a63c66e3973e94d4f368366087ef59427003106a99bb46c46728"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "78d49db050951e7d62fd3773c446298ed08ecd2df7e064250c552cf134957816"
  end

  deprecate! date: "2023-11-02", because: "uses deprecated `node@16`"

  depends_on "node@16" # try `node` after https://github.com/znck/grammarly/issues/334

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "open3"
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
    Open3.popen3("#{bin}/grammarly-languageserver --stdio") do |stdin, stdout, _, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
