class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "e1d8cc0479fb91b461373ca55d66a49704fa01376bfcd0e62b8523b563505dff"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47d4e24586a830fda03277716e0bfd2aadb6219b033c0de78fde165bb3f47f7a"
    sha256 cellar: :any, arm64_sequoia: "313a0c1e91a815ca0f392a51ec7deed478f5023224a43b3026b581c8d585ceb0"
    sha256 cellar: :any, arm64_sonoma:  "a54d25e7b0d0393ac975e260a25655ba3b84df1db65bb9cb57ce1279de35c7fe"
    sha256 cellar: :any, sonoma:        "52cc401498b811626e1efe2d6562d2a6542b43bbfc8b7b22a0457e5553a94e8c"
    sha256 cellar: :any, arm64_linux:   "fd253b026058cc5aacaa6c57ded7b3f0af27239813b6e845a3bd1e32476affba"
    sha256 cellar: :any, x86_64_linux:  "5650b4b500d9c9681c83d6e9f2195165d3b22f98d63f24294b1eef370825f372"
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
