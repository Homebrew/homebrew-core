class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "9f9a393007b1f8804492c7ecdc2a3cf9b1fe34d4c9f2a1df86ab147146ed2672"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a8881200f5a142666208f19717b34abc453a2899a2ad6a7cd1a6d2146aa0ffaf"
    sha256 cellar: :any, arm64_tahoe:       "af7c94726da87af7cc60d9d0fb78602440883c35794d52d901a74b7eb11b7f83"
    sha256 cellar: :any, arm64_sequoia:     "37f115471c27c9e96aaae54f111d73ed38be77f93ef459857cf28b38f5002252"
    sha256 cellar: :any, arm64_linux:       "f71215e8ee3e04f34b32ed02d4ad02c2b7ce255cc951081c92e9c53fbeba6f02"
    sha256 cellar: :any, x86_64_linux:      "74597b857bb98fa732eb2adc679f44eb6915b830b2ff1af5f5b0d93d76cbcc47"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "just" => :build
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "mix", "local.hex", "--force", "--if-missing"
    system "mix", "local.rebar", "--force", "--if-missing"

    system "just", "install", "--prefix=#{prefix}"

    # Use brewed ca-certificates PEM file instead of the bundled copy
    cacerts = libexec.glob("expert/lib/*/priv/engine_source/apps/engine/deps/castore/priv/cacerts.pem").fetch(0)
    rm cacerts
    cacerts.make_relative_symlink Formula["openssl@4"].pkgetc/"cert.pem"
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
