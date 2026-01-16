class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.26.0.tar.gz"
  sha256 "7964f7c20d9d466ac24e5d0ceb482d130b277df43fbc4c0917249af71e6cf598"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19cfe53cfbe6f2678ef39ad539c91ef137b7758dd82b5ebd7314c8acb4ab7a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da4bf1442f0bfd21fbfbbec5a7cd7b0f05eb624578ff53a2bbda3b29664da68c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80eb6c86849bd113a7650235ab1a7efcdf47564fe7b34117f84ea216e4ebc027"
    sha256 cellar: :any_skip_relocation, sonoma:        "412876e7da24accfc7f15ef33b7ede13b609b925998b470987190480a3201402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99fdae0423cc88bded73bfd25ff31cd9496baefd17f3ef162828be7760b4b464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82f4b0dcafcee4bb3c35a894e7685905fba7b6d44eec9efa3d8e883fcaf44509"
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
