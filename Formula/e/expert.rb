class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "7841bcb8ffdddf055c45e790bb3e2bf8abe775b41d8b38e203a7c147fd8af14e"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8d05d0f092538bc0a3e5472a6602c0a27f5b86c48b5b3a3ed72d176813a770ed"
    sha256 cellar: :any, arm64_tahoe:       "3fed0ad522f651d5bae134626ecadd63e8d251591710f5d37d40046b1c4a2d04"
    sha256 cellar: :any, arm64_sequoia:     "f04226a4163ee365622ea88dd3f8f7f9445aec07b67fa18f2355a85be620b717"
    sha256 cellar: :any, arm64_linux:       "0e977632d2628294c9718131b11cd41ea6e32d134aeba9e2b06fd188c7b9bf5a"
    sha256 cellar: :any, x86_64_linux:      "621872b25d4ab7f55515363e73ee75583ddccf0f59b97614eefe9eeebb531e6f"
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
