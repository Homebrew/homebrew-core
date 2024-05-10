require "language/node"

class AnsibleLanguageServer < Formula
  desc "Language Server for Ansible Files"
  homepage "https://github.com/ansible/ansible-language-server"
  url "https://registry.npmjs.org/@ansible/ansible-language-server/-/ansible-language-server-1.2.1.tgz"
  sha256 "1614a212952e778e97a8dc1a4a84a2bf195764931cdc8e022eea4895e4b677ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3ce4f46a6a3768999ab20d8c97877fec96eadff8b4d0895b61870db69f65fdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60fa43eca628baf765c7985e3e628660f3f61d8ae6666f9a80cda4e7fae65286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60fa43eca628baf765c7985e3e628660f3f61d8ae6666f9a80cda4e7fae65286"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60fa43eca628baf765c7985e3e628660f3f61d8ae6666f9a80cda4e7fae65286"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3ce4f46a6a3768999ab20d8c97877fec96eadff8b4d0895b61870db69f65fdb"
    sha256 cellar: :any_skip_relocation, ventura:        "60fa43eca628baf765c7985e3e628660f3f61d8ae6666f9a80cda4e7fae65286"
    sha256 cellar: :any_skip_relocation, monterey:       "60fa43eca628baf765c7985e3e628660f3f61d8ae6666f9a80cda4e7fae65286"
    sha256 cellar: :any_skip_relocation, big_sur:        "60fa43eca628baf765c7985e3e628660f3f61d8ae6666f9a80cda4e7fae65286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abc09d916281ceb0ee5ffed77be92564ba8c3dd992231af50027a9d29a12063"
  end

  deprecate! date: "2024-03-15", because: :repo_archived

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
