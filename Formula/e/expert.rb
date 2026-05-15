class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "ff6fc6620672a2d593d6e1db4435e0ab73e2470203e62003773f72a9615dcfc8"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04e776ae268b5b8ad8caadb064949be197ac906a1dea943f7a7f5e8e4b492aab"
    sha256 cellar: :any,                 arm64_sequoia: "54510bd21db63769e8a58b53dac22c4516a7f09a1b69281bbba129eda53e0a8c"
    sha256 cellar: :any,                 arm64_sonoma:  "d90f329d9e456874ae22d9a155b7cf156f14d4e84224f6c053a5260054206e26"
    sha256 cellar: :any,                 sonoma:        "46e94fc3bc8e155fe5806546e7b0a92b80f76839fc66496dc5fb40af9f9d1e86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46b053a7007fd473a5bb8ec5d4ceb0f4605580610d94627a378ce39bcde0e238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5abf568f9f7b24dbd74cd61ff3c4f2b893026d55e37b29a85ea0acec2e3aef"
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
