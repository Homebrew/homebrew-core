class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "cbe134490b7bf52953807c82503bf109131f5e90d5c883cee3210c0a5e4f636b"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "694ee7d258941644b78dd74432aa9f2073018b80073220dc7cb69377decb485f"
    sha256 cellar: :any, arm64_sequoia: "12736e5e5f00bb767869966f0447f78967d138b0783be356ca55f4562a9fe966"
    sha256 cellar: :any, arm64_sonoma:  "de2b3c25cc786be209e49f1278913daf651cad8625817010945d67a60da05722"
    sha256 cellar: :any, sonoma:        "706fc2791bbcb8ddb040f5776ffec6653d74c25c378d9ab548bd618901db2656"
    sha256 cellar: :any, arm64_linux:   "0c7c06db6064765a84f981d3b06d6d0f0ff6c3d07074168694ef9ada305bd127"
    sha256 cellar: :any, x86_64_linux:  "b63f74b3ed96334db5df7d31611c10227bec2f728d1082d6f170cc5fa16e9715"
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
