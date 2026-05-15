class AnsibleLanguageServer < Formula
  desc "Language Server for Ansible Files"
  homepage "https://github.com/ansible/vscode-ansible"
  url "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-26.5.0.tgz"
  sha256 "cdace3a89292c8c73ba9f7fa80688e9211a5e0d29f679034d86bb9f2d21f8d8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fdf0d90c1ea5863e9acab4f7b5c57ff1a5c22d28821e76e05afbd03c318fe15f"
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
