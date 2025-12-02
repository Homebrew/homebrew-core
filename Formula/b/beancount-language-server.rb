class BeancountLanguageServer < Formula
  desc "Language server for beancount files"
  homepage "https://github.com/polarmutex/beancount-language-server"
  url "https://github.com/polarmutex/beancount-language-server/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "d8a7ed7eba4461d851574bcb42c614180513144bd56e429f803997a3555dfdaf"
  license "MIT"
  head "https://github.com/polarmutex/beancount-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8d4cc8564372d39f54e6e97c4f281fdcafb80a1532a6f5331c25a34965a1571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b7377fc99ef879688e3f7bfab1e85ac155c1d583db4dd5e4ef84c200b026ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a5131af0d419d63a342539a0ab3aca43fe3dfc16d755f49dfa33440bdb4c57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f3d2946f89f9262d2970c998617d0d068ad05a89195dd2936f1d2f59733f9d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d8f70336fdbf1f1dabfedf317f39375a9c7a3c84ba4ae25d219e1b947e0f465"
    sha256 cellar: :any_skip_relocation, ventura:       "b848c9af6a74cf7768da405c1d244a7d35f66f230c06e0818f30a16584928511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "253473490238b1c2faf4d80f5d79149cdebaf6b035cfd57fb99dddef4a474e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6125cd5ffaf34194e79987170c30d737ef6bc4a04b2e53a007bbd68344863a74"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/lsp")
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

    Open3.popen3(bin/"beancount-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end

    assert_match version.to_s, shell_output("#{bin}/beancount-language-server --version")
  end
end
