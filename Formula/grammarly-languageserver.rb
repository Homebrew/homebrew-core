require "language/node"

class GrammarlyLanguageserver < Formula
  desc "Language Server for Grammarly"
  homepage "https://github.com/znck/grammarly"
  url "https://registry.npmjs.org/grammarly-languageserver/-/grammarly-languageserver-0.0.4.tgz"
  sha256 "0d50b88059b5a63c66e3973e94d4f368366087ef59427003106a99bb46c46728"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
