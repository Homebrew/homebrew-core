class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.29.0.tar.gz"
  sha256 "f18311b2a1e60830a3c85078edb06789955eaee1c963a4cb67aa2636271dcb8a"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78a9c0a390f4893f4412423bb10828fecec14cd9682d9875ad0b4256353b5e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18bdeae5cfb6a925b730cbd25ca2b4b1a641b08f45ba4ee76880de209a15eb19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f611eafd253e3cd00703d4f8259635c606df8678bd8462dbf7f9e68f3a5b72d"
    sha256 cellar: :any_skip_relocation, sonoma:        "770416f2f8abb9e5243de37ec8b027f31852eddf505f26af800cdccaf1ebd086"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5eba7e45ffa58a3edda89b8fc287b1cdb88d8a25b357690c7b240ecef188fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f9f3149741fccf804f00ee8a5be0d50a8861cc4e2bd7186840b48eae779510"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end
