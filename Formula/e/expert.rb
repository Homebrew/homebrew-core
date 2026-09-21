class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "18fa9533a7d43d5cff52ba1ea687eee9b69adc599ae84ab9fec54d813c23e31c"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "83423e6a7fc0808395d13aed3f72a72bb9246761afa72ff5738ff6d326adff5b"
    sha256 cellar: :any, arm64_tahoe:       "e4b0c56a273e94830ffdb5be8135b86fc52e0c6f222b6519d46553f36bbbe45c"
    sha256 cellar: :any, arm64_sequoia:     "bf7d63646c502151b266025a9282829c312e73e55e47221030353878561a275c"
    sha256 cellar: :any, arm64_sonoma:      "ffe3f335f0f987205f1989601483e454210940b26f9c5e58e1123bfa9cd2608b"
    sha256 cellar: :any, arm64_linux:       "42dc9b27744894c5b57de513820275bca3c4d2bd0d7f8714b599702694ca7fbb"
    sha256 cellar: :any, x86_64_linux:      "872dafd98305dc1f1e0b42db3786a7a15f783d667ef4586e90b58262a33d9dc7"
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
