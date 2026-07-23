class AnsibleLanguageServer < Formula
  desc "Language Server for Ansible Files"
  homepage "https://github.com/ansible/vscode-ansible"
  url "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-26.6.0.tgz"
  sha256 "b9774c8755003dc921c822ea63cef63175807d9c0d3f7eb0f53602a31e447948"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c669fa7e8a2e4f823b6a09c953a4de371310e690e9233faa05fdc8f3f997d2f1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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

    Open3.popen3(bin/"ansible-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
