require "language/node"

class GrammarlyLanguageserver < Formula
  desc "Language Server for Grammarly"
  homepage "https://github.com/znck/grammarly"
  url "https://registry.npmjs.org/grammarly-languageserver/-/grammarly-languageserver-0.0.4.tgz"
  sha256 "0d50b88059b5a63c66e3973e94d4f368366087ef59427003106a99bb46c46728"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f728288cb46659e57ec3e8577561d2c590fe45ae673be3cac69a41da4c32537"
  end

  depends_on "node@16"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"grammarly-languageserver").write <<~EOS
      #! /usr/bin/env sh

      #{Formula["node@16"].bin}/node #{libexec}/bin/grammarly-languageserver "$@"
    EOS
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
