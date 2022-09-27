require "language/node"

class AnsibleLanguageServer < Formula
  desc "Language Server for Ansible Files"
  homepage "https://github.com/ansible/ansible-language-server"
  url "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-0.10.3.tgz"
  sha256 "ced6847c8183adc0aaadd2d42893883337f02c756bdd0f6b3aca2493891b754f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "120a1f39ce8952336cf51bca7d7f97d6cdd515995b1a60a0ec91e8ff47ec0740"
  end

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

    Open3.popen3("#{bin}/ansible-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
