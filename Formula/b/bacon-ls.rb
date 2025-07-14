class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.21.0.tar.gz"
  sha256 "85435d98030c54ef52598827018f9df587d60ff7a8dff3915198778546ca7c93"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b82dd97acdfd53d0dc57a7fe745f259b15d790423031b040adb6df4a404d0ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2aa0aedfa2e59d69864ce7d7168dfcd48d70ce020670ece905eee32829b5d696"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35df93544835de2c3c8a48cb79b0c3378c92621e290caf885ab1cec5e2781f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fcf90e18aab7226fe5ed3de68a7a61e3765a89ee726a580d04040033bd400df"
    sha256 cellar: :any_skip_relocation, ventura:       "57328026d6c8a343cb2ca2d2b463eabb615f6b5481e383e8020a24ea9ec908ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a258ecb0f26c3ce44cf31cdb67a1cf931233c2eaf16c60b45d291383f3493b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f301ef0cef24db40b1a2a3c644a7867965713c6440d1893d37a78182dd5872e"
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
