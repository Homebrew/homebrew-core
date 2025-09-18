class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.22.0.tar.gz"
  sha256 "b9d32ceee3fc5389bf3baf887ac1fd02e88f53a58f35fc9fe41c8543dd7a613a"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba1148ff7fd597cfa2d14a5530115a7575e06c8023c8140fd9361dcf820aefd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0df0d775c1457b55c04a688505e6376104ebdcd6529733b7f4070ca98c5d0139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ecea0916bac30c51414c9c499eec50e3f32ec56dab4a6a9ce9e229628e90019"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "165e8c9f8643b5df200004739650877fd0b4f0c311783209de19fdd7f1cbb98a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b197b81414d99594e38525c64204ffe3ce3ca8e29ba6b4c49a8aed32962a6dc"
    sha256 cellar: :any_skip_relocation, ventura:       "db3054e560914367cdce163aca3ef94bbd3d8f58520066a1d3ac69f9b39de4ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fcebafe26dcc571419e49e6371bbbaefa98a4f6e32bc4f88c9ca6fcf23f6083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64cba45a7728e9600bcc0fde786fc9fb96e15061072811b5f042daade1796a6a"
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
