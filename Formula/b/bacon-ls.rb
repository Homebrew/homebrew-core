class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.19.0.tar.gz"
  sha256 "a1376645260417273c0953b713c49921104e93d39ce1568966cb03cf718549c7"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad8a2cdc5d886f6cea04cd657d726aba88116b6597bdf8894d338ed2f57c5eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b98949b48328f288120b11c6f636e9e87dc2e0aa25286fc75905cdd43f17c6b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf60074b4b9b41f2d55f610fa89b087df5658ff13333a8413995111242f5475b"
    sha256 cellar: :any_skip_relocation, sonoma:        "178cd51623840e2877ce990953a03e379d01be1442d1b0c8591f207b70ef4e55"
    sha256 cellar: :any_skip_relocation, ventura:       "f606acfe698dc6d78790c4be6dce75f32bc75549cf7c9d8b8203e0f7dbba912e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cc3ddce0807e354e6731296cd9f96a7379d31c8cda55d513a92b367146b0f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f30465a7b4c3657adb157bd8b72124886dec0809b0dd58ec1382035f934ffafc"
  end

  depends_on "rust" => :build

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
