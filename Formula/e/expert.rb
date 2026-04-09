class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e93ac9a2a8576697d327e3bea3005b755111a62986977d66140b9e5df5af6be2"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f9f4b95e9ca15c8c2b53c7ee9c346d53c24df1509d1be124868c350b9042c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef5f201bbb3d9d686c40522a172bd791dceeca164e4c61902b7f56b32ca3d36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e4d0bdb1935d6edf3ee3ced12625277bef20a197582681b2a4c582899cd9b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae7f9ce56676e96018dc3c0bba839567b514432078891ad8712efc4b1faf316f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c80d566b7bf95b48166a9a1737414f6a9d27a2cb067614344e753338a138de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9158f8ecf797e2b959ef28491256effb3d447ee23b852a8d57075ac6be194e0b"
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
