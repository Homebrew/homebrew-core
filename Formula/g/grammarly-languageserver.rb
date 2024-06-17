require "language/node"

class GrammarlyLanguageserver < Formula
  desc "Language Server for Grammarly"
  homepage "https://github.com/znck/grammarly"
  url "https://registry.npmjs.org/grammarly-languageserver/-/grammarly-languageserver-0.0.4.tgz"
  sha256 "0d50b88059b5a63c66e3973e94d4f368366087ef59427003106a99bb46c46728"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7433d92272f07c1cd865850dbf5db445aaef83b4ce00cebd49b8faad6aaf88b4"
  end

  deprecate! date: "2023-11-02", because: "uses deprecated `node@16`"

  depends_on "node@16" # try `node` after https://github.com/znck/grammarly/issues/334

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
