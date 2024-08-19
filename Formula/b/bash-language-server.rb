class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-5.4.0.tgz"
  sha256 "398971fee90b72014d72ca63b163e8f19d3c7db9528de8e43075c2ffa579b7b2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51ba85e12eebbb1f73c17113ee5cf4db979519a2ee8d61c31b652c841b15fda4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51ba85e12eebbb1f73c17113ee5cf4db979519a2ee8d61c31b652c841b15fda4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51ba85e12eebbb1f73c17113ee5cf4db979519a2ee8d61c31b652c841b15fda4"
    sha256 cellar: :any_skip_relocation, sonoma:         "51ba85e12eebbb1f73c17113ee5cf4db979519a2ee8d61c31b652c841b15fda4"
    sha256 cellar: :any_skip_relocation, ventura:        "51ba85e12eebbb1f73c17113ee5cf4db979519a2ee8d61c31b652c841b15fda4"
    sha256 cellar: :any_skip_relocation, monterey:       "51ba85e12eebbb1f73c17113ee5cf4db979519a2ee8d61c31b652c841b15fda4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c002af8e83868ebb2664838b79c00f7e4405448547ea5e3d64b889ea2e4f67f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
