class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "cbebb733de1996ff870b5171d6abd5d0bfa1e366d47eb210977edbcde82216d6"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07740c303e629b73bd68a8c60132f3e341ee55db516d670f9ecbc4adb04469dc"
    sha256 cellar: :any,                 arm64_sequoia: "fec3beccbea6b8989ba29827073a978f11ccd10ec05cf6ec0aa92d424cdde355"
    sha256 cellar: :any,                 arm64_sonoma:  "51e41656c62a306f3a7928586b9660f051d0cb3c783eeaa8b9f6052be6b441e8"
    sha256 cellar: :any,                 sonoma:        "9afd140f0aab679961561095e0fae90f7e8bdcc688694bd343b356716cad0246"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "287e02538b3e3fb2e45f6328d3ec72bc184e8a85df1accdbeaa39fc7ae461e96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "692f5ad9a449be28299692c169b104988f567d085620ca9a1aa72eddcff0cbde"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "just" => :build
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "mix", "local.hex", "--force", "--if-missing"
    system "mix", "local.rebar", "--force", "--if-missing"
    system "just", "install", "--prefix=#{prefix}"
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

    Open3.popen3(bin/"expert", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
