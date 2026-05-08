class AnsibleLanguageServer < Formula
  desc "Language Server for Ansible Files"
  homepage "https://github.com/ansible/vscode-ansible"
  url "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-26.4.6.tgz"
  sha256 "fed4584fc0fc4a8abd8abb03ae5fedd0fe93f588c90751c62b9e029b2451c24d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db11e4c50cd1c8e0014860b4d23efdfa70d19b1fe871ae34eba10892a0e05f54"
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
