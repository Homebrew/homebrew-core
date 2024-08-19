class PurescriptLanguageServer < Formula
  desc "Language Server Protocol server for PureScript"
  homepage "https://github.com/nwolverson/purescript-language-server"
  url "https://registry.npmjs.org/purescript-language-server/-/purescript-language-server-0.18.0.tgz"
  sha256 "4814f287375c5b03ff71d11ab43e2eab7c87bb4d856d22db70cd45f9051ec327"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13bab131f4c76717facc48989f3449674c336a6ecde00bd1b3afc1d8d5917096"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13bab131f4c76717facc48989f3449674c336a6ecde00bd1b3afc1d8d5917096"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13bab131f4c76717facc48989f3449674c336a6ecde00bd1b3afc1d8d5917096"
    sha256 cellar: :any_skip_relocation, sonoma:         "13bab131f4c76717facc48989f3449674c336a6ecde00bd1b3afc1d8d5917096"
    sha256 cellar: :any_skip_relocation, ventura:        "13bab131f4c76717facc48989f3449674c336a6ecde00bd1b3afc1d8d5917096"
    sha256 cellar: :any_skip_relocation, monterey:       "13bab131f4c76717facc48989f3449674c336a6ecde00bd1b3afc1d8d5917096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25410574878aaeff7b211222108eb127f332f48d28ffce06069fd041455feeb9"
  end

  depends_on "node"
  depends_on "purescript"

  def install
    system "npm", "install", *std_npm_args
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

    Open3.popen3(bin/"purescript-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
